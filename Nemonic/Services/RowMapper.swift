import Foundation

/// Maps OCR'd table rows (an array of cell-strings per row) to typed `ScreenerRow`s
/// using a known `ScreenerSchema` for column order.
nonisolated struct RowMapper: Sendable {

    /// `tableRows` is what comes out of the OCR step — the first row is assumed to be the header
    /// (already filtered out by the caller). Each subsequent row is the cells of a stock entry,
    /// left-to-right, in the same order as `schema.orderedKeys`.
    ///
    /// The first key of every schema is the ticker code; we always keep its value as `.string`.
    func map(tableRows: [[String]], using schema: ScreenerSchema) -> [ScreenerRow] {
        let keys = schema.orderedKeys
        guard !keys.isEmpty else { return [] }

        var output: [ScreenerRow] = []
        for cells in tableRows {
            if cells.allSatisfy({ $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                continue
            }
            var pairs: [ScreenerRow.Pair] = []
            for (i, key) in keys.enumerated() {
                let raw = i < cells.count ? cells[i] : ""
                let value: JSONValue
                if i == 0 {
                    // First column is always the ticker code — preserve as string.
                    value = .string(raw.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    value = NumericValueParser.parse(raw)
                }
                pairs.append(ScreenerRow.Pair(key: key, value: value))
            }
            output.append(ScreenerRow(pairs: pairs))
        }
        return output
    }
}
