import Testing
@testable import Nemonic

struct ScreenerClassifierTests {

    private func makeRegistry() -> ScreenerRegistry {
        ScreenerRegistry(schemas: [
            ScreenerSchema(id: "confluence",
                           displayName: "Confluence Universe Filter",
                           titleAliases: ["confluence", "universe filter"],
                           orderedKeys: ["code"]),
            ScreenerSchema(id: "quiet-bandar-accumulation",
                           displayName: "Quiet Bandar Accumulation",
                           titleAliases: ["quiet bandar", "bandar accumulation"],
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

    /// Regression: Image #4 — Stockbit Quiet Bandar Accumulation capture. The sidebar lists
    /// several custom screeners that contain alias-overlapping words (`Bandar Accumulation
    /// Uptrend`, `Foreign + Bandar Confluence`, `Wyckoff Spring`). Selected screener title
    /// repeats in the panel header, which must still win.
    @Test func picksQuietBandarFromImage4Sidebar() {
        let c = ScreenerClassifier(registry: makeRegistry())
        let pageText = """
        Screener Confluence Universe Filter Quiet Bandar Accumulation
        Bulkowski BB Squeeze Breakout With-Trend Pullback (Statistical Edge)
        Livermore Pivotal Point Classical Trend-Follower Coulling Stopping Volume
        wyckoff-2 — Phase C Spring Composite Preset — High-conviction long
        Quality Frequency Spike Bandar Rotation (early entry on the flip)
        Distribution Warning Wyckoff Spring (shakeout + reclaim)
        Foreign + Bandar Confluence Bandar Accumulation Uptrend
        Quiet Bandar Accumulation | Edit | 1 Symbols
        Symbol Bandar Accum/Dist Bandar Value
        BANK
        """
        #expect(c.classify(pageText: pageText)?.id == "quiet-bandar-accumulation")
    }

    /// Regression: a Stockbit Confluence capture has the *whole sidebar* of saved screener names
    /// AND the selected screener's title in the panel header. The selected one appears twice
    /// (sidebar entry + header), the others appear once. Without occurrence-counting, BB Squeeze
    /// wins because it has three matching aliases in the sidebar.
    @Test func picksSelectedScreenerEvenWhenSidebarListsAllOthers() {
        let c = ScreenerClassifier(registry: makeRegistry())
        let pageText = """
        Screener Confluence Universe Filter Quiet Bandar Accumulation
        Bulkowski BB Squeeze Breakout With-Trend Pullback Livermore Pivotal Point
        Classical Trend-Follower Coulling Stopping Volume wyckoff-2 — Phase C Spring
        Confluence Universe Filter | Edit | 5 Symbols
        """
        #expect(c.classify(pageText: pageText)?.id == "confluence")
    }
}
