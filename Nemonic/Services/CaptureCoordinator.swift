import Foundation
import Observation

/// Top-level pipeline: screenshot URL → OCR → classify → map → write JSON → trash PNG.
/// Owns the watcher and publishes events the UI can render.
@Observable
@MainActor
final class CaptureCoordinator {

    enum Status: Equatable, Sendable {
        case idle
        case watching
        case stopped
        case failed(String)
    }

    struct Event: Identifiable, Equatable, Sendable {
        let id: UUID
        let timestamp: Date
        let message: String
        let kind: Kind
        enum Kind: Sendable { case info, success, warning, error }
    }

    private(set) var status: Status = .idle
    private(set) var events: [Event] = []
    let watchlist: Watchlist

    private let desktop: URL
    private let registry: ScreenerRegistry
    private let classifier: ScreenerClassifier
    private let mapper: RowMapper
    private let ocr: any OCRService
    private let sink: FileSink
    private let watcher: ScreenshotWatcher

    init(desktop: URL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop"),
         registry: ScreenerRegistry,
         watchlist: Watchlist,
         ocr: any OCRService = VisionOCRService(),
         mapper: RowMapper = RowMapper(),
         sink: FileSink = FileSink()) {
        self.desktop = desktop
        self.registry = registry
        self.watchlist = watchlist
        self.classifier = ScreenerClassifier(registry: registry)
        self.mapper = mapper
        self.ocr = ocr
        self.sink = sink
        self.watcher = ScreenshotWatcher(directory: desktop)
        watchlist.rebuild()
    }

    func start() {
        do {
            try watcher.start { [weak self] url in
                Task { @MainActor [weak self] in
                    await self?.process(screenshot: url)
                }
            }
            status = .watching
            log("Watching \(desktop.path)", kind: .info)
        } catch {
            status = .failed(error.localizedDescription)
            log("Failed to start watcher: \(error.localizedDescription)", kind: .error)
        }
    }

    func stop() {
        watcher.stop()
        status = .stopped
        log("Stopped.", kind: .info)
    }

    // MARK: - Pipeline

    func process(screenshot url: URL) async {
        log("Detected \(url.lastPathComponent)", kind: .info)
        do {
            let result = try await ocr.recognize(imageAt: url)
            guard let schema = classifier.classify(pageText: result.pageText) else {
                log("No screener matched for \(url.lastPathComponent) — skipped (not deleting)", kind: .warning)
                return
            }
            log("Identified screener: \(schema.displayName)", kind: .info)

            // Use the largest table; drop the header row (the schema gives us the column order).
            guard let table = result.tables.first else {
                log("No table detected in image — skipped (not deleting)", kind: .warning)
                return
            }
            let dataRows = Array(table.rows.dropFirst())
            let mapped = mapper.map(tableRows: dataRows, using: schema)
            guard !mapped.isEmpty else {
                log("OCR produced no usable rows — skipped (not deleting)", kind: .warning)
                return
            }

            let written = try sink.write(rows: mapped, for: schema, outputDirectory: desktop)
            log("Wrote \(written.lastPathComponent) (\(mapped.count) rows)", kind: .success)

            watchlist.rebuild()
            if !watchlist.signals.isEmpty {
                log("Watchlist: \(watchlist.signals.count) signal(s)", kind: .success)
            }

            try sink.trash(url)
            log("Trashed \(url.lastPathComponent)", kind: .success)
        } catch {
            log("Failed processing \(url.lastPathComponent): \(error.localizedDescription)", kind: .error)
        }
    }

    private func log(_ message: String, kind: Event.Kind) {
        let event = Event(id: UUID(), timestamp: Date(), message: message, kind: kind)
        events.insert(event, at: 0)
        if events.count > 50 { events.removeLast(events.count - 50) }
    }
}
