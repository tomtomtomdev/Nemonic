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
