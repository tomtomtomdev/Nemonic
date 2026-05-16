import Foundation

/// Risk-based position sizing.
///
/// Given an entry price and an invalidation (stop) price, return the share count, IDR position
/// value, and account allocation %. Caps at `maxPositionPct` so a tight stop doesn't overdraw
/// the account.
nonisolated struct PositionSizer: Sendable {

    let accountSize: Int        // IDR
    let riskPerTrade: Double    // fraction, e.g. 0.01
    let maxPositionPct: Double  // fraction, e.g. 0.15

    struct Plan: Equatable, Sendable {
        let shares: Int
        let positionValue: Int   // IDR
        let allocationPct: Double
    }

    func size(entry: Int, stop: Int) -> Plan? {
        guard stop < entry, entry > 0 else { return nil }

        let riskCapital = Double(accountSize) * riskPerTrade
        let riskPerShare = Double(entry - stop)
        let riskShares = Int(floor(riskCapital / riskPerShare))

        let maxPositionValue = Double(accountSize) * maxPositionPct
        let capShares = Int(floor(maxPositionValue / Double(entry)))

        guard capShares > 0 else { return nil }

        let shares = min(riskShares, capShares)
        guard shares > 0 else { return nil }

        let positionValue = shares * entry
        let allocationPct = Double(positionValue) / Double(accountSize)
        return Plan(shares: shares, positionValue: positionValue, allocationPct: allocationPct)
    }
}
