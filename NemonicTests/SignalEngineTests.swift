import Testing
import Foundation
@testable import Nemonic

struct SignalEngineTests {

    private let sizer = PositionSizer(accountSize: 43_000_000, riskPerTrade: 0.01, maxPositionPct: 0.15)
    private var engine: SignalEngine { SignalEngine(sizer: sizer) }

    private let confluence = ConfluenceContext(levels: [
        "BBCA": .init(price: 9875, priceMA50: 9540, priceMA200: 9120),
        "BMRI": .init(price: 5825, priceMA50: 5640, priceMA200: 5410),
        "ARTO": .init(price: 3200, priceMA50: 3050, priceMA200: 2800),
    ])

    // MARK: - #6 Murphy classical-trend-follower

    @Test func murphyEntryIsCurrentPriceStopIsMA50() {
        let rows = [
            ScreenerRow([
                ("code", .string("BBCA")),
                ("price", .int(9875)),
                ("price-ma-50", .int(9540)),
            ])
        ]
        let out = engine.signals(screenerId: "classical-trend-follower", rows: rows, confluence: confluence)
        #expect(out.count == 1)
        #expect(out[0].ticker == "BBCA")
        #expect(out[0].entry == 9875)
        #expect(out[0].stop == 9540)
        #expect(out[0].plan.shares > 0)
        #expect(out[0].plan.allocationPct <= 0.15 + 1e-6)
    }

    @Test func murphyDropsTickerNotInConfluence() {
        // SIDO is not in the confluence set — strict pre-filter must drop it.
        let rows = [
            ScreenerRow([
                ("code", .string("SIDO")),
                ("price", .int(800)),
                ("price-ma-50", .int(740)),
            ])
        ]
        #expect(engine.signals(screenerId: "classical-trend-follower", rows: rows, confluence: confluence).isEmpty)
    }

    @Test func murphyDropsRowWithoutRequiredFields() {
        let rows = [
            ScreenerRow([("code", .string("BBCA"))])  // missing price/ma50
        ]
        #expect(engine.signals(screenerId: "classical-trend-follower", rows: rows, confluence: confluence).isEmpty)
    }

    // MARK: - #2 Bandarmology

    @Test func bandarReadsPriceFromConfluence() {
        // #2 JSON has no price column. Engine must look up BBCA's price from confluence.
        let rows = [
            ScreenerRow([
                ("code", .string("BBCA")),
                ("bandar-accum-dist", .int(1247)),
                ("bandar-value", .string("12.45B")),
            ])
        ]
        let out = engine.signals(screenerId: "quiet-bandar-accumulation", rows: rows, confluence: confluence)
        #expect(out.count == 1)
        #expect(out[0].entry == 9875)   // from confluence
        #expect(out[0].stop == 9540)
    }

    @Test func bandarRequiresConfluencePresence() {
        let rows = [
            ScreenerRow([("code", .string("UNKN")), ("bandar-accum-dist", .int(100))])
        ]
        #expect(engine.signals(screenerId: "quiet-bandar-accumulation", rows: rows, confluence: confluence).isEmpty)
    }

    // MARK: - Unknown screener

    @Test func unknownScreenerIdReturnsEmpty() {
        let rows = [ScreenerRow([("code", .string("BBCA"))])]
        #expect(engine.signals(screenerId: "not-yet-implemented", rows: rows, confluence: confluence).isEmpty)
    }
}
