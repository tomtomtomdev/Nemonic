import Foundation
import AppKit

/// Writes the produced JSON next to the source screenshot (i.e. on the Desktop)
/// and moves the original screenshot to the Trash (recoverable, unlike `removeItem`).
nonisolated struct FileSink: Sendable {

    func write(rows: [ScreenerRow],
               for schema: ScreenerSchema,
               outputDirectory: URL) throws -> URL {
        let target = outputDirectory.appendingPathComponent("\(schema.id).json")
        let json = JSONWriter.write(rows)
        try json.write(to: target, atomically: true, encoding: .utf8)
        return target
    }

    func trash(_ url: URL) throws {
        try FileManager.default.trashItem(at: url, resultingItemURL: nil)
    }
}
