import Foundation

/// Watches a directory for newly added `Screenshot *.png` files and emits their URLs.
/// Uses `DispatchSourceFileSystemObject` on the directory file descriptor — a write event
/// fires whenever a child is added/removed/renamed. We snapshot directory contents on each
/// event and emit any new screenshot we haven't seen yet.
final class ScreenshotWatcher: @unchecked Sendable {

    let directory: URL
    let queue: DispatchQueue
    private var source: DispatchSourceFileSystemObject?
    private var fileDescriptor: Int32 = -1
    private var seen: Set<URL> = []
    private var onNew: (@Sendable (URL) -> Void)?

    init(directory: URL,
         queue: DispatchQueue = DispatchQueue(label: "nemonic.watcher", qos: .utility)) {
        self.directory = directory
        self.queue = queue
    }

    deinit { stop() }

    func start(onNewScreenshot: @escaping @Sendable (URL) -> Void) throws {
        stop()
        self.onNew = onNewScreenshot

        // Prime the seen set so we don't immediately replay everything already on Desktop.
        seen = Set(currentScreenshots())

        let fd = open(directory.path, O_EVTONLY)
        guard fd >= 0 else {
            throw WatcherError.openFailed(directory)
        }
        fileDescriptor = fd

        let src = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .extend],
            queue: queue
        )
        src.setEventHandler { [weak self] in
            self?.handleEvent()
        }
        src.setCancelHandler { [weak self] in
            if let self, self.fileDescriptor >= 0 {
                close(self.fileDescriptor)
                self.fileDescriptor = -1
            }
        }
        src.resume()
        source = src
    }

    func stop() {
        source?.cancel()
        source = nil
        onNew = nil
    }

    enum WatcherError: Error {
        case openFailed(URL)
    }

    /// Public so existing screenshots can be processed at app start if you want — currently unused.
    func currentScreenshots() -> [URL] {
        let fm = FileManager.default
        guard let entries = try? fm.contentsOfDirectory(at: directory,
                                                        includingPropertiesForKeys: [.isRegularFileKey],
                                                        options: [.skipsHiddenFiles]) else {
            return []
        }
        return entries.filter { Self.isScreenshot($0) }
    }

    static func isScreenshot(_ url: URL) -> Bool {
        let name = url.lastPathComponent
        return name.hasPrefix("Screenshot ") && name.lowercased().hasSuffix(".png")
    }

    // MARK: - Event handling

    private func handleEvent() {
        // Debounce: screenshots are written incrementally; wait a beat for the file to finish.
        queue.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            guard let self else { return }
            let now = Set(self.currentScreenshots())
            let added = now.subtracting(self.seen)
            self.seen = now
            for url in added.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
                self.onNew?(url)
            }
        }
    }
}
