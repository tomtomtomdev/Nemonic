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

    @Test func padsMissingCellsWithEmptyString() {
        let rows = [["GJTL"]]
        let mapped = RowMapper().map(tableRows: rows, using: schema)
        #expect(mapped.first?.pairs.count == 5)
        #expect(mapped.first?.pairs.last?.value == .string(""))
    }

    @Test func firstColumnIsAlwaysStringEvenIfNumeric() {
        // hypothetical numeric code — still treat as string
        let rows = [["12345", "1", "2", "3B", "4%"]]
        let mapped = RowMapper().map(tableRows: rows, using: schema)
        #expect(mapped.first?.pairs.first?.value == .string("12345"))
    }
}
