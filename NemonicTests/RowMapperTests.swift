import Testing
@testable import Nemonic

struct RowMapperTests {

    private let schema = ScreenerSchema(
        id: "confluence",
        displayName: "Confluence Universe Filter",
        titleAliases: ["confluence"],
        orderedKeys: ["code", "value-ma-20", "price-ma-50", "1-month-net-foreign-flow", "rsi-14"]
    )

    @Test func mapsOneRowPreservingColumnOrder() {
        let rows = [["GJTL", "8,973,753,750", "1127", "26.79B", "60.25%"]]
        let mapped = RowMapper().map(tableRows: rows, using: schema)
        #expect(mapped == [
            ScreenerRow([
                ("code", .string("GJTL")),
                ("value-ma-20", .int(8_973_753_750)),
                ("price-ma-50", .int(1127)),
                ("1-month-net-foreign-flow", .string("26.79B")),
                ("rsi-14", .string("60.25%")),
            ])
        ])
    }

    @Test func skipsEmptyRows() {
        let rows = [["", "", "", "", ""], ["GJTL", "1", "2", "3B", "4%"]]
        #expect(RowMapper().map(tableRows: rows, using: schema).count == 1)
    }

    // MARK: - Ticker validation (IDX = 4 uppercase letters)

    @Test func dropsRowWhenFirstCellIsNotAFourLetterTicker() {
        let rows = [
            ["Confluence Universe Filter", "1", "2", "3B", "4%"], // sidebar label noise
            ["BUY", "1", "2", "3B", "4%"],                         // 3 letters
            ["GOTOX", "1", "2", "3B", "4%"],                       // 5 letters
            ["12345", "1", "2", "3B", "4%"],                       // digits
            ["goto", "1", "2", "3B", "4%"],                        // lowercase
            ["GJTL", "1", "2", "3B", "4%"],                        // valid
        ]
        let mapped = RowMapper().map(tableRows: rows, using: schema)
        #expect(mapped.count == 1)
        #expect(mapped.first?.pairs.first?.value == .string("GJTL"))
    }

    // MARK: - Minimum cell count (tolerate up to 2 missing trailing columns)

    @Test func dropsRowsWithTooFewCells() {
        // schema has 5 columns → tolerate ≥ 3 cells.
        let rows = [
            ["GJTL"],                               // 1 cell — drop
            ["GJTL", "1"],                          // 2 cells — drop
            ["GJTL", "1", "2"],                     // 3 cells — keep, pad
            ["GJTL", "1", "2", "3B", "4%"],         // full row — keep
        ]
        let mapped = RowMapper().map(tableRows: rows, using: schema)
        #expect(mapped.count == 2)
    }

    @Test func padsMissingTrailingCellsWithEmptyString() {
        // 3 cells against a 5-column schema — kept and padded.
        let rows = [["GJTL", "1", "2"]]
        let mapped = RowMapper().map(tableRows: rows, using: schema)
        #expect(mapped.first?.pairs.count == 5)
        #expect(mapped.first?.pairs.last?.value == .string(""))
    }

    @Test func minimumCellsScalesWithSchemaWidth() {
        // 9-column schema → tolerate ≥ 7 cells.
        let wide = ScreenerSchema(
            id: "bb-squeeze-breakout",
            displayName: "Bulkowski BB Squeeze Breakout",
            titleAliases: ["bb squeeze"],
            orderedKeys: ["code", "a", "b", "c", "d", "e", "f", "g", "h"]
        )
        let rows = [
            Array(repeating: "1", count: 6).withPrefix("GJTL"),  // 7 — keep
            Array(repeating: "1", count: 5).withPrefix("GJTL"),  // 6 — drop
        ]
        let mapped = RowMapper().map(tableRows: rows, using: wide)
        #expect(mapped.count == 1)
    }
}

private extension Array where Element == String {
    func withPrefix(_ prefix: String) -> [String] { [prefix] + self }
}
