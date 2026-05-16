import Foundation

/// A trade signal produced by SignalEngine for a single ticker that hit a screener and survived
/// the #1 confluence pre-filter. Carries the buy trigger price, the invalidation stop, and the
/// risk-based position plan.
nonisolated struct ScreenerSignal: Equatable, Sendable, Identifiable {
    let ticker: String
    let screenerId: String        // e.g. "classical-trend-follower", "quiet-bandar-accumulation"
    let entry: Int                // IDR — buy trigger
    let stop: Int                 // IDR — invalidation level
    let plan: PositionSizer.Plan  // shares + allocation %

    var id: String { "\(screenerId)|\(ticker)" }
}
