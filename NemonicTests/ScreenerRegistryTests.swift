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

    @Test func bbSqueezeSchemaHasSqueezeRatioKey() throws {
        let registry = try ScreenerRegistry.load(bundle: .main)
        let bb = try #require(registry.schema(forID: "bb-squeeze-breakout"))
        #expect(bb.orderedKeys.contains("bb-squeeze-ratio"))
        #expect(bb.orderedKeys.contains("bb-upper-20"))
    }
}
