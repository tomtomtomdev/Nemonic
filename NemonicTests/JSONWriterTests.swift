import Testing
@testable import Nemonic

struct JSONWriterTests {

    @Test func emptyRowsProducesEmptyArray() {
        #expect(JSONWriter.write([]) == "[]\n")
    }

    @Test func preservesKeyOrderAndMixesIntAndString() {
        let row = ScreenerRow([
            ("code", .string("GJTL")),
            ("value-ma-20", .int(8_973_753_750)),
            ("rsi-14", .string("60.25%")),
        ])
        let expected = """
        [
            {
                "code": "GJTL",
                "value-ma-20": 8973753750,
                "rsi-14": "60.25%"
            }
        ]

        """
        #expect(JSONWriter.write([row]) == expected)
    }

    @Test func multipleRowsSeparatedByCommas() {
        let r1 = ScreenerRow([("code", .string("A")), ("n", .int(1))])
        let r2 = ScreenerRow([("code", .string("B")), ("n", .int(2))])
        let out = JSONWriter.write([r1, r2])
        #expect(out.contains("\"A\""))
        #expect(out.contains("\"B\""))
        #expect(out.contains("    },\n    {\n"))
    }
}
