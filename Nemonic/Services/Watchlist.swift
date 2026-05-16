import Foundation
import Observation

/// Derived view of trade signals built from the JSON files on Desktop.
///
/// Flow:
///   1. Read `~/Desktop/confluence.json` → `ConfluenceContext` (the strict #1 pre-filter).
///   2. For each other `<screener-id>.json` on Desktop, load its rows and ask `SignalEngine`
///      to translate hits → `ScreenerSignal` (entry, stop, position plan).
///   3. Publish the de-duplicated, allocation-sorted list.
///
/// Rebuild is triggered by `CaptureCoordinator` whenever a new screener JSON is written.
@Observable
@MainActor
final class Watchlist {

    private(set) var signals: [ScreenerSignal] = []
    private(set) var lastBuiltAt: Date? = nil
    private(set) var hasConfluence: Bool = false

    private let desktop: URL
    private let registry: ScreenerRegistry
    private let engine: SignalEngine
    private let loader: ScreenerJSONLoader

    init(desktop: URL,
         registry: ScreenerRegistry,
         engine: SignalEngine,
         loader: ScreenerJSONLoader = ScreenerJSONLoader()) {
        self.desktop = desktop
        self.registry = registry
        self.engine = engine
        self.loader = loader
    }

    func rebuild() {
        guard let confluenceSchema = registry.schema(forID: "confluence") else { return }
        let confluenceURL = desktop.appendingPathComponent("confluence.json")
        guard let confluenceRows = try? loader.load(from: confluenceURL, schema: confluenceSchema) else {
            hasConfluence = false
            signals = []
            lastBuiltAt = Date()
            return
        }
        hasConfluence = true
        let context = ConfluenceContext.build(from: confluenceRows)

        var all: [ScreenerSignal] = []
        for schema in registry.schemas where schema.id != "confluence" {
            let url = desktop.appendingPathComponent("\(schema.id).json")
            guard let rows = try? loader.load(from: url, schema: schema) else { continue }
            all.append(contentsOf: engine.signals(
                screenerId: schema.id,
                rows: rows,
                confluence: context
            ))
        }

        signals = all.sorted { $0.plan.allocationPct > $1.plan.allocationPct }
        lastBuiltAt = Date()
    }
}
