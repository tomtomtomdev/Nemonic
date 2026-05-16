import Foundation

/// Writes an array of `ScreenerRow` as a pretty-printed JSON array that **preserves key order**.
/// `JSONEncoder` / `JSONSerialization` don't guarantee dictionary ordering, so we render manually.
nonisolated enum JSONWriter {

    static func write(_ rows: [ScreenerRow], indent: String = "    ") -> String {
        if rows.isEmpty { return "[]\n" }

        var out = "[\n"
        for (i, row) in rows.enumerated() {
            out += indent + "{\n"
            for (j, pair) in row.pairs.enumerated() {
                let comma = (j == row.pairs.count - 1) ? "" : ","
                out += indent + indent + "\"\(escape(pair.key))\": \(render(pair.value))\(comma)\n"
            }
            let comma = (i == rows.count - 1) ? "" : ","
            out += indent + "}\(comma)\n"
        }
        out += "]\n"
        return out
    }

    private static func render(_ value: JSONValue) -> String {
        switch value {
        case .int(let n): return String(n)
        case .string(let s): return "\"\(escape(s))\""
        }
    }

    private static func escape(_ s: String) -> String {
        var out = ""
        out.reserveCapacity(s.count)
        for ch in s {
            switch ch {
            case "\\": out += "\\\\"
            case "\"": out += "\\\""
            case "\n": out += "\\n"
            case "\r": out += "\\r"
            case "\t": out += "\\t"
            default:
                if ch.asciiValue ?? 0x20 < 0x20 {
                    out += String(format: "\\u%04x", ch.asciiValue!)
                } else {
                    out.append(ch)
                }
            }
        }
        return out
    }
}
