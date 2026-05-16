import Foundation

nonisolated struct ScreenerRegistry: Sendable {

    let schemas: [ScreenerSchema]

    /// Loads all bundled `sample-*.json` files and combines them with the static title metadata below.
    /// Each sample JSON contributes the **ordered list of keys** for its screener.
    static func load(bundle: Bundle = .main) throws -> ScreenerRegistry {
        var schemas: [ScreenerSchema] = []

        for entry in Self.titleMetadata {
            guard let url = bundle.url(forResource: "sample-\(entry.id)", withExtension: "json") else {
                throw RegistryError.missingResource("sample-\(entry.id).json")
            }
            let data = try Data(contentsOf: url)
            let keys = try orderedKeys(from: data)
            schemas.append(ScreenerSchema(
                id: entry.id,
                displayName: entry.displayName,
                titleAliases: entry.aliases,
                orderedKeys: keys
            ))
        }

        return ScreenerRegistry(schemas: schemas)
    }

    func schema(forID id: String) -> ScreenerSchema? {
        schemas.first { $0.id == id }
    }

    enum RegistryError: Error, Equatable {
        case missingResource(String)
        case decodeFailed(String)
    }

    // MARK: - Title metadata (kept in code because samples don't carry titles)

    struct TitleInfo: Sendable {
        let displayName: String
        let aliases: [String]
    }

    static let titleMetadata: [(id: String, displayName: String, aliases: [String])] = [
        ("confluence",                   "Confluence Universe Filter",          ["confluence", "universe filter"]),
        ("quiet-bandar-accumulation",    "Quiet Bandar Accumulation",           ["quiet bandar", "bandar accumulation"]),
        ("bb-squeeze-breakout",          "Bulkowski BB Squeeze Breakout",       ["bb squeeze", "bollinger squeeze", "squeeze breakout", "bulkowski"]),
        ("with-trend-pullback",          "With-Trend Pullback (Statistical Edge)", ["with-trend pullback", "with trend pullback", "statistical edge"]),
        ("livermore-pivotal-point",      "Livermore Pivotal Point",             ["livermore", "pivotal point"]),
        ("classical-trend-follower",     "Classical Trend-Follower",            ["classical trend", "trend-follower", "trend follower"]),
        ("coulling-stopping-volume",     "Coulling Stopping Volume",            ["coulling", "stopping volume"]),
        ("wyckoff-phase-c-spring",       "Wyckoff Phase C Spring",              ["wyckoff", "phase c spring", "phase-c spring", "spring"]),
    ]

    // MARK: - Helpers

    /// JSONSerialization doesn't preserve key order, so we sniff the keys directly from the bytes.
    /// We look at the first object only — that's enough to fix column order.
    private static func orderedKeys(from data: Data) throws -> [String] {
        guard let text = String(data: data, encoding: .utf8) else {
            throw RegistryError.decodeFailed("not utf-8")
        }
        guard let firstBrace = text.firstIndex(of: "{") else {
            throw RegistryError.decodeFailed("no opening brace")
        }
        // Walk the first object, collecting keys in source order.
        var keys: [String] = []
        var i = text.index(after: firstBrace)
        var depth = 1
        while i < text.endIndex && depth > 0 {
            let ch = text[i]
            if ch == "{" { depth += 1 }
            else if ch == "}" { depth -= 1; if depth == 0 { break } }
            else if ch == "\"" {
                // Possible key — only count if we're at depth 1 and the next non-space char after the closing quote is ':'.
                let keyStart = text.index(after: i)
                guard let keyEnd = nextUnescapedQuote(in: text, from: keyStart) else {
                    throw RegistryError.decodeFailed("unterminated string")
                }
                let key = String(text[keyStart..<keyEnd])
                // Skip whitespace after closing quote and see if it's ':' — that confirms this string is a key.
                var j = text.index(after: keyEnd)
                while j < text.endIndex, text[j].isWhitespace { j = text.index(after: j) }
                if depth == 1, j < text.endIndex, text[j] == ":" {
                    keys.append(key)
                    // Advance past the value — easiest is to skip to the next top-level ',' or '}'.
                    i = try skipValue(in: text, from: text.index(after: j))
                    continue
                } else {
                    i = text.index(after: keyEnd)
                    continue
                }
            }
            i = text.index(after: i)
        }
        return keys
    }

    private static func nextUnescapedQuote(in s: String, from start: String.Index) -> String.Index? {
        var i = start
        while i < s.endIndex {
            if s[i] == "\\" {
                i = s.index(i, offsetBy: 2, limitedBy: s.endIndex) ?? s.endIndex
                continue
            }
            if s[i] == "\"" { return i }
            i = s.index(after: i)
        }
        return nil
    }

    /// Returns the index *after* the value (i.e. positioned at the comma or closing brace).
    private static func skipValue(in s: String, from start: String.Index) throws -> String.Index {
        var i = start
        // Skip leading whitespace
        while i < s.endIndex, s[i].isWhitespace { i = s.index(after: i) }
        guard i < s.endIndex else { return i }

        switch s[i] {
        case "\"":
            guard let end = nextUnescapedQuote(in: s, from: s.index(after: i)) else {
                throw RegistryError.decodeFailed("unterminated string value")
            }
            return s.index(after: end)
        case "{", "[":
            let opener = s[i]
            let closer: Character = (opener == "{") ? "}" : "]"
            var depth = 1
            i = s.index(after: i)
            while i < s.endIndex && depth > 0 {
                if s[i] == "\"" {
                    guard let end = nextUnescapedQuote(in: s, from: s.index(after: i)) else {
                        throw RegistryError.decodeFailed("unterminated string in object")
                    }
                    i = s.index(after: end)
                    continue
                }
                if s[i] == opener { depth += 1 }
                else if s[i] == closer { depth -= 1 }
                i = s.index(after: i)
            }
            return i
        default:
            // Number, bool, null — read until ',' or '}' or ']'
            while i < s.endIndex, s[i] != ",", s[i] != "}", s[i] != "]" {
                i = s.index(after: i)
            }
            return i
        }
    }
}
