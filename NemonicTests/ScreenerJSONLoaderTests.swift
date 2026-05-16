import Testing
import Foundation
@testable import Nemonic

struct ScreenerJSONLoaderTests {

    private let schema = ScreenerSchema(
        id: "classical-trend-follower",
        displayName: "Classical Trend-Follower",
        titleAliases: ["classical trend"],
        orderedKeys: ["code", "price", "price-ma-50", "rsi-14"]
    )

    @Test func roundTripsIntsAndStrings() throws {
        let url = try writeTemp("""
        [
          {"code":"BBCA","price":9875,"price-ma-50":9540,"rsi-14":"58.42%"},
          {"code":"BMRI","price":5825,"price-ma-50":5640,"rsi-14":"61.83%"}
        ]
        """)
        let rows = try ScreenerJSONLoader().load(from: url, schema: schema)
        #expect(rows.count == 2)
        #expect(rows[0].string(for: "code") == "BBCA")
        #expect(rows[0].int(for: "price") == 9875)
        #expect(rows[0].int(for: "price-ma-50") == 9540)
        #expect(rows[0].string(for: "rsi-14") == "58.42%")
    }

    @Test func skipsKeysAbsentFromTheRow() throws {
        // RowMapper can emit rows missing some columns when OCR is incomplete.
        let url = try writeTemp(#"[{"code":"BBCA","price":9875}]"#)
        let rows = try ScreenerJSONLoader().load(from: url, schema: schema)
        #expect(rows[0].pairs.count == 2) // code + price only
    }

    @Test func throwsOnInvalidJSON() throws {
        let url = try writeTemp("not json")
        #expect(throws: Error.self) {
            try ScreenerJSONLoader().load(from: url, schema: schema)
        }
    }

    // MARK: - Helpers

    private func writeTemp(_ contents: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("nemonic-test-\(UUID().uuidString).json")
        try contents.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
