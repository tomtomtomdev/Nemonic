import Foundation

/// Reads a written `<screener-id>.json` file back into `[ScreenerRow]`, preserving the schema's
/// column order. Numeric cells round-trip as `.int`; everything else stays `.string` (matching
/// `JSONWriter` / `NumericValueParser` contract).
nonisolated struct ScreenerJSONLoader: Sendable {

    enum LoadError: Error, Equatable {
        case notFound
        case decodeFailed
    }

    func load(from url: URL, schema: ScreenerSchema) throws -> [ScreenerRow] {
        let data = try Data(contentsOf: url)
        guard let array = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw LoadError.decodeFailed
        }
        return array.map { dict in
            let pairs: [ScreenerRow.Pair] = schema.orderedKeys.compactMap { key in
                guard let raw = dict[key] else { return nil }
                return ScreenerRow.Pair(key: key, value: Self.value(from: raw))
            }
            return ScreenerRow(pairs: pairs)
        }
    }

    private static func value(from raw: Any) -> JSONValue {
        if let n = raw as? Int { return .int(n) }
        if let n = raw as? NSNumber {
            // Distinguish Int-bearing NSNumber from doubles (NSNumber unifies them in JSONSerialization).
            let asDouble = n.doubleValue
            if asDouble.truncatingRemainder(dividingBy: 1) == 0,
               asDouble >= Double(Int.min), asDouble <= Double(Int.max) {
                return .int(Int(asDouble))
            }
            return .string("\(n)")
        }
        if let s = raw as? String { return .string(s) }
        return .string("\(raw)")
    }
}
