import Testing
@testable import Nemonic

struct NumericValueParserTests {

    @Test func plainInteger() {
        #expect(NumericValueParser.parse("1127") == .int(1127))
    }

    @Test func integerWithCommas() {
        #expect(NumericValueParser.parse("8,973,753,750") == .int(8_973_753_750))
    }

    @Test func percentValueStaysString() {
        #expect(NumericValueParser.parse("60.25%") == .string("60.25%"))
    }

    @Test func billionSuffixStaysString() {
        #expect(NumericValueParser.parse("26.79B") == .string("26.79B"))
    }

    @Test func negativeBillionInParensStaysString() {
        #expect(NumericValueParser.parse("(424.38B)") == .string("(424.38B)"))
    }

    @Test func decimalWithoutSuffixStaysString() {
        // sample-bb-squeeze-breakout.json stores 0.072 as "0.072"
        #expect(NumericValueParser.parse("0.072") == .string("0.072"))
    }

    @Test func emptyAndDashCellsBecomeEmptyString() {
        #expect(NumericValueParser.parse("") == .string(""))
        #expect(NumericValueParser.parse("-") == .string(""))
        #expect(NumericValueParser.parse("—") == .string(""))
    }

    @Test func surroundingWhitespaceStripped() {
        #expect(NumericValueParser.parse("  1230  ") == .int(1230))
    }
}
