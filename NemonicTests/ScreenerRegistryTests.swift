import Testing
import Foundation
@testable import Nemonic

struct ScreenerRegistryTests {

    /// Loads the real bundled samples — this also smoke-tests the JSON key-order extractor.
    @Test func loadsAllEightScreenersFromBundle() throws {
        let registry = try ScreenerRegistry.load(bundle: .main)
        #expect(registry.schemas.count == 8)
    }

    @Test func confluenceSchemaKeysAreInExpectedOrder() throws {
        let registry = try ScreenerRegistry.load(bundle: .main)
        let confluence = try #require(registry.schema(forID: "confluence"))
        #expect(confluence.orderedKeys.first == "code")
        #expect(confluence.orderedKeys.contains("value-ma-20"))
        #expect(confluence.orderedKeys.contains("rsi-14"))
        // "code" must be index 0 — that's the contract the row mapper depends on.
        #expect(confluence.orderedKeys.firstIndex(of: "code") == 0)
    }

    @Test func withTrendPullbackSchemaMatchesStockbitPanelColumns() throws {
        // Stockbit's "With-Trend Pullback (Statistical Edge)" panel shows columns in the
        // order: Symbol | Price MA 20 | Price MA 50 | Price MA 200 | Price | Price MA 10 |
        // RSI (14) | Stochastic (14,1,3) | Volume | Volume MA 20. RowMapper maps by index,
        // so the schema must mirror that ordering exactly — otherwise price/MA cells land
        // on the wrong keys.
        let registry = try ScreenerRegistry.load(bundle: .main)
        let wtp = try #require(registry.schema(forID: "with-trend-pullback"))
        #expect(wtp.orderedKeys == [
            "code", "price-ma-20", "price-ma-50", "price-ma-200", "price", "price-ma-10",
            "rsi-14", "stochastic-14-1-3", "volume", "volume-ma-20"
        ])
    }

    @Test func quietBandarSchemaMatchesStockbitPanelColumns() throws {
        // Stockbit's "Quiet Bandar Accumulation" panel orders the two Bandar Value moving
        // averages with MA 20 *before* MA 10 — the same shape as the recent BB Squeeze /
        // Livermore fix. RowMapper maps by index, so any drift would push MA 10 values onto
        // the MA 20 key.
        let registry = try ScreenerRegistry.load(bundle: .main)
        let qb = try #require(registry.schema(forID: "quiet-bandar-accumulation"))
        #expect(qb.orderedKeys == [
            "code", "bandar-accum-dist", "bandar-value", "bandar-value-ma-20",
            "bandar-value-ma-10", "net-foreign-buy-streak", "1-month-net-foreign-flow",
            "frequency", "frequency-analyzer-ma-50", "value", "value-ma-20"
        ])
    }

    @Test func classicalTrendFollowerSchemaMatchesStockbitPanelColumns() throws {
        // Stockbit's "Classical Trend-Follower" panel sorts the trend stack as
        // Price MA 50 → Price MA 200 → Price (i.e. slowest MA values first, current price
        // last among the price columns) — Price is NOT the first numeric column.
        let registry = try ScreenerRegistry.load(bundle: .main)
        let tf = try #require(registry.schema(forID: "classical-trend-follower"))
        #expect(tf.orderedKeys == [
            "code", "price-ma-50", "price-ma-200", "price", "macd-12-26", "rsi-14",
            "stochastic-14-1-3", "volume-ma-20", "volume-ma-50"
        ])
    }

    @Test func coullingStoppingVolumeSchemaMatchesStockbitPanelColumns() throws {
        // Stockbit's "Coulling Stopping Volume" panel shows columns as
        // Symbol | Low Price | Price MA 20 | Price | Open Price | Volume | ... .
        // Note Price MA 20 lands BEFORE Price + Open Price (different from the bundled
        // schema's original ordering, which would have aligned Price MA 20 onto Open Price).
        let registry = try ScreenerRegistry.load(bundle: .main)
        let cs = try #require(registry.schema(forID: "coulling-stopping-volume"))
        #expect(cs.orderedKeys == [
            "code", "low-price", "price-ma-20", "price", "open-price", "volume",
            "volume-ma-20", "1-day-volume-change", "foreign-flow-ma-20", "frequency-spike"
        ])
    }

    @Test func livermorePivotalPointSchemaMatchesStockbitPanelColumns() throws {
        // Stockbit's "Livermore Pivotal Point" panel shows columns in the order:
        // Symbol | Price | BB Upper (20) | Price MA 200 | Price MA 20 | Price MA 50 |
        // Volume | Volume MA 50 | Value | Value MA 50 | 1 Day Volume Change |
        // Net Foreign Buy / Sell. RowMapper maps by index, so the schema must mirror
        // that ordering exactly — otherwise MA cells land on the wrong keys (e.g. MA 200
        // would be misread as MA 20).
        let registry = try ScreenerRegistry.load(bundle: .main)
        let liv = try #require(registry.schema(forID: "livermore-pivotal-point"))
        #expect(liv.orderedKeys == [
            "code", "price", "bb-upper-20", "price-ma-200", "price-ma-20", "price-ma-50",
            "volume", "volume-ma-50", "value", "value-ma-50",
            "1-day-volume-change", "net-foreign-buy-sell"
        ])
    }

    @Test func bbSqueezeSchemaMatchesStockbitPanelColumns() throws {
        // Sample mirrors the 7 columns Stockbit actually shows for the Bulkowski BB Squeeze
        // Breakout panel: Symbol | Price | BB Upper (20) | Volume | Volume MA 20 |
        // 1 Day Volume Change | Price MA 50. The squeeze ratio + BB Lower are part of the
        // filter logic but not displayed, so they aren't in the schema.
        let registry = try ScreenerRegistry.load(bundle: .main)
        let bb = try #require(registry.schema(forID: "bb-squeeze-breakout"))
        #expect(bb.orderedKeys == [
            "code", "price", "bb-upper-20", "volume", "volume-ma-20",
            "1-day-volume-change", "price-ma-50"
        ])
    }
}
