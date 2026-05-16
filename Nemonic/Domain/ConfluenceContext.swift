import Foundation

/// Snapshot of the latest #1 Confluence Universe Filter run.
///
/// Carries the survivor tickers AND their price levels (the #1 JSON is the single source of
/// truth for price + key MAs since downstream screeners like #2 Bandarmology have no price
/// column). Strict pre-filter: only tickers present here can generate signals.
nonisolated struct ConfluenceContext: Equatable, Sendable {

    struct TickerLevels: Equatable, Sendable {
        let price: Int
        let priceMA50: Int
        let priceMA200: Int
    }

    let levels: [String: TickerLevels]

    var tickers: Set<String> { Set(levels.keys) }

    func levels(for ticker: String) -> TickerLevels? { levels[ticker] }

    /// Build from #1 confluence JSON rows. Rows missing `price` or `price-ma-50` are dropped.
    static func build(from rows: [ScreenerRow]) -> ConfluenceContext {
        var out: [String: TickerLevels] = [:]
        for row in rows {
            guard let code = row.string(for: "code"),
                  let price = row.int(for: "price"),
                  let ma50 = row.int(for: "price-ma-50") else { continue }
            let ma200 = row.int(for: "price-ma-200") ?? ma50
            out[code] = TickerLevels(price: price, priceMA50: ma50, priceMA200: ma200)
        }
        return ConfluenceContext(levels: out)
    }
}

extension ScreenerRow {
    func int(for key: String) -> Int? {
        guard let pair = pairs.first(where: { $0.key == key }) else { return nil }
        if case .int(let v) = pair.value { return v }
        return nil
    }
    func string(for key: String) -> String? {
        guard let pair = pairs.first(where: { $0.key == key }) else { return nil }
        if case .string(let v) = pair.value { return v }
        return nil
    }
}
