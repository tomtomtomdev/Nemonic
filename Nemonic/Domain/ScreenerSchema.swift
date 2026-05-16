import Foundation

nonisolated struct ScreenerSchema: Equatable, Sendable {
    let id: String                 // file-stem id, e.g. "confluence", "bb-squeeze-breakout"
    let displayName: String        // human title as shown in screenshot, e.g. "Confluence Universe Filter"
    let titleAliases: [String]     // lowercased substrings that should match this screener
    let orderedKeys: [String]      // JSON keys in the order they appear as table columns (first = "code")
}

nonisolated struct ScreenerRow: Equatable, Sendable {
    let pairs: [Pair]

    nonisolated struct Pair: Equatable, Sendable {
        let key: String
        let value: JSONValue
    }

    init(pairs: [Pair]) { self.pairs = pairs }

    /// Convenience tuple-style initializer for tests and call sites.
    init(_ pairs: [(String, JSONValue)]) {
        self.pairs = pairs.map { Pair(key: $0.0, value: $0.1) }
    }
}
