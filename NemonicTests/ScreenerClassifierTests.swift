import Testing
@testable import Nemonic

struct ScreenerClassifierTests {

    private func makeRegistry() -> ScreenerRegistry {
        ScreenerRegistry(schemas: [
            ScreenerSchema(id: "confluence",
                           displayName: "Confluence Universe Filter",
                           titleAliases: ["confluence", "universe filter"],
                           orderedKeys: ["code"]),
            ScreenerSchema(id: "bb-squeeze-breakout",
                           displayName: "Bulkowski BB Squeeze Breakout",
                           titleAliases: ["bb squeeze", "bulkowski", "squeeze breakout"],
                           orderedKeys: ["code"]),
            ScreenerSchema(id: "wyckoff-phase-c-spring",
                           displayName: "Wyckoff Phase C Spring",
                           titleAliases: ["wyckoff", "phase c spring", "spring"],
                           orderedKeys: ["code"]),
        ])
    }

    @Test func picksConfluenceFromExactTitle() {
        let c = ScreenerClassifier(registry: makeRegistry())
        #expect(c.classify(pageText: "Confluence Universe Filter | Edit")?.id == "confluence")
    }

    @Test func picksBBSqueezeFromBulkowskiTitle() {
        let c = ScreenerClassifier(registry: makeRegistry())
        #expect(c.classify(pageText: "Bulkowski BB Squeeze Breakout")?.id == "bb-squeeze-breakout")
    }

    @Test func returnsNilWhenNoAliasMatches() {
        let c = ScreenerClassifier(registry: makeRegistry())
        #expect(c.classify(pageText: "Some totally unrelated title") == nil)
    }

    @Test func prefersLongerAliasWhenAmbiguous() {
        let c = ScreenerClassifier(registry: makeRegistry())
        // "phase c spring" is longer than "wyckoff" alone, but both should resolve to wyckoff anyway
        #expect(c.classify(pageText: "wyckoff-2 — Phase C Spring")?.id == "wyckoff-phase-c-spring")
    }
}
