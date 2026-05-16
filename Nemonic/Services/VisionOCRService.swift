import Foundation
import Vision
import CoreGraphics
import ImageIO

/// Production OCR implementation using the macOS 15+ Swift-native Vision API.
///
/// Strategy:
/// 1. `RecognizeDocumentsRequest` (macOS 26+) for structured tables.
/// 2. `RecognizeTextRequest` for reliable full-page text used to classify the screener.
/// 3. Fallback to spatial grouping over text observations when no table is detected.
nonisolated struct VisionOCRService: OCRService {

    func recognize(imageAt url: URL) async throws -> OCRResult {
        guard let cgImage = Self.loadCGImage(at: url) else {
            throw OCRError.invalidImage(url)
        }

        let handler = ImageRequestHandler(cgImage)

        let textRequest: RecognizeTextRequest = {
            var r = RecognizeTextRequest()
            r.recognitionLevel = .accurate
            r.usesLanguageCorrection = false
            return r
        }()
        let docRequest = RecognizeDocumentsRequest()

        async let textTask = handler.perform(textRequest)
        async let docTask = handler.perform(docRequest)

        let texts = try await textTask
        let docs = try await docTask

        let pageText = texts
            .compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: "\n")

        let docTables = Self.tablesFromDocuments(docs)
        let tables: [OCRTable]
        if !docTables.isEmpty {
            tables = docTables
        } else {
            let fallback = Self.tableFromText(observations: texts)
            tables = fallback.rows.isEmpty ? [] : [fallback]
        }

        return OCRResult(pageText: pageText, tables: tables)
    }

    enum OCRError: Error {
        case invalidImage(URL)
    }

    // MARK: - Image loading

    private static func loadCGImage(at url: URL) -> CGImage? {
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(src, 0, nil)
    }

    // MARK: - Document tables

    private static func tablesFromDocuments(_ docs: [DocumentObservation]) -> [OCRTable] {
        var out: [OCRTable] = []
        for obs in docs {
            for table in obs.document.tables {
                var rows: [[String]] = []
                for row in table.rows {
                    let cells = row.map { $0.content.text.transcript }
                    rows.append(cells)
                }
                let area = areaOf(table.boundingRegion)
                out.append(OCRTable(rows: rows, area: area))
            }
        }
        return out.sorted { $0.area > $1.area }
    }

    private static func areaOf(_ region: NormalizedRegion) -> Double {
        let r = region.boundingBox
        return Double(r.width * r.height)
    }

    // MARK: - Text-spatial fallback

    /// Group RecognizedTextObservations into rows by Y proximity, then split each row's words
    /// into cells where adjacent-word X gaps exceed a threshold relative to typical word width.
    private static func tableFromText(observations: [RecognizedTextObservation]) -> OCRTable {
        struct Word { let text: String; let box: CGRect }
        let words: [Word] = observations.compactMap { (obs: RecognizedTextObservation) -> Word? in
            guard let s = obs.topCandidates(1).first?.string else { return nil }
            let r = obs.boundingBox
            return Word(text: s, box: CGRect(x: r.origin.x, y: r.origin.y, width: r.width, height: r.height))
        }
        guard !words.isEmpty else { return OCRTable(rows: [], area: 0) }

        let yTolerance = (words.map { $0.box.height }.max() ?? 0.01) * 0.6
        var rows: [[Word]] = []
        for w in words.sorted(by: { $0.box.midY > $1.box.midY }) {
            if let anchor = rows.last?.first,
               abs(anchor.box.midY - w.box.midY) < yTolerance {
                rows[rows.count - 1].append(w)
            } else {
                rows.append([w])
            }
        }

        let cellRows: [[String]] = rows.map { row in
            let sorted = row.sorted { $0.box.minX < $1.box.minX }
            guard !sorted.isEmpty else { return [] }
            let typicalWidth = sorted.map { $0.box.width }.reduce(0, +) / Double(sorted.count)
            var cells: [String] = [sorted[0].text]
            for i in 1..<sorted.count {
                let gap = sorted[i].box.minX - sorted[i-1].box.maxX
                if gap > typicalWidth * 1.2 {
                    cells.append(sorted[i].text)
                } else {
                    cells[cells.count - 1] += " " + sorted[i].text
                }
            }
            return cells
        }

        let minX = words.map { $0.box.minX }.min() ?? 0
        let maxX = words.map { $0.box.maxX }.max() ?? 0
        let minY = words.map { $0.box.minY }.min() ?? 0
        let maxY = words.map { $0.box.maxY }.max() ?? 0
        let area = Double((maxX - minX) * (maxY - minY))
        return OCRTable(rows: cellRows, area: area)
    }
}
