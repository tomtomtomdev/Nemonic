import Foundation

/// Translates screener hits into trade signals.
///
/// Strict #1 pre-filter: a ticker only generates a signal if it also appears in the most recent
/// Confluence Universe Filter run (`ConfluenceContext`). Per-screener rules below match the
/// trigger + invalidation table in `screeners.md`.
nonisolated struct SignalEngine: Sendable {

    let sizer: PositionSizer

    func signals(screenerId: String,
                 rows: [ScreenerRow],
                 confluence: ConfluenceContext) -> [ScreenerSignal] {
        guard let rule = Self.rule(for: screenerId) else { return [] }
        var out: [ScreenerSignal] = []
        for row in rows {
            guard let ticker = row.string(for: "code"),
                  let levels = confluence.levels(for: ticker),
                  let (entry, stop) = rule(row, levels),
                  let plan = sizer.size(entry: entry, stop: stop) else { continue }
            out.append(ScreenerSignal(
                ticker: ticker,
                screenerId: screenerId,
                entry: entry,
                stop: stop,
                plan: plan
            ))
        }
        return out
    }

    // MARK: - Per-screener rules
    //
    // Each rule maps (row from the screener JSON, confluence levels for the ticker) → (entry, stop).
    // Returns nil if the row lacks data needed for that screener.

    typealias Rule = (ScreenerRow, ConfluenceContext.TickerLevels) -> (entry: Int, stop: Int)?

    private static func rule(for screenerId: String) -> Rule? {
        switch screenerId {
        case "classical-trend-follower":
            // #6 Murphy — already in trend, no separate trigger. Entry = current price.
            // Invalidation: close below Price MA 50.
            return { row, levels in
                guard let price = row.int(for: "price"),
                      let ma50 = row.int(for: "price-ma-50") else { return nil }
                return (entry: price, stop: ma50)
            }

        case "quiet-bandar-accumulation":
            // #2 Bandarmology — signal-based, no price in own JSON. Cross-ref #1 confluence:
            // entry = #1 price, stop = #1 Price MA 50 (proxy invalidation since #2's own
            // invalidation is non-price ["Bandar Accum/Dist flips negative"]).
            return { _, levels in
                (entry: levels.price, stop: levels.priceMA50)
            }

        default:
            return nil
        }
    }
}
