import Foundation

nonisolated enum NumericValueParser {

    /// Convert raw OCR cell text into the JSON value that should be stored.
    ///
    /// Rule (mirrors what the sample JSON files do):
    /// - Pure integers (possibly with thousands separators) → `.int`
    /// - Anything with a suffix (B/M/K/T), `%`, `(parens)`, or a decimal point → `.string`, preserved as-is after light cleanup
    /// - Empty / "-" / "—" → `.string("")`
    static func parse(_ raw: String) -> JSONValue {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == "-" || trimmed == "—" {
            return .string("")
        }

        let normalized = trimmed.replacingOccurrences(of: " ", with: "")

        // Anything that looks formatted (suffix, percent, parens, decimal) is preserved verbatim.
        if containsFormattingMarkers(normalized) {
            return .string(normalized)
        }

        // Pure integer with optional comma separators and optional leading minus.
        let digitsOnly = normalized.replacingOccurrences(of: ",", with: "")
        if let n = Int(digitsOnly) {
            return .int(n)
        }

        return .string(normalized)
    }

    private static func containsFormattingMarkers(_ s: String) -> Bool {
        if s.contains("%") || s.contains("(") || s.contains(")") || s.contains(".") {
            return true
        }
        for ch in s {
            if ch.isLetter { return true }
        }
        return false
    }
}
