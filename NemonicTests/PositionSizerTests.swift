import Testing
import Foundation
@testable import Nemonic

struct PositionSizerTests {

    // 43M IDR account, 1% risk per trade (= 430k IDR risk capital), 15% max position (= 6.45M IDR).
    private let sizer = PositionSizer(
        accountSize: 43_000_000,
        riskPerTrade: 0.01,
        maxPositionPct: 0.15
    )

    @Test func sizesNormalSetup() {
        // Entry 1000, stop 900 → risk/share 100. 430k / 100 = 4300 shares. 4300×1000 = 4.3M = 10% of 43M.
        let p = sizer.size(entry: 1000, stop: 900)!
        #expect(p.shares == 4300)
        #expect(p.positionValue == 4_300_000)
        #expect(abs(p.allocationPct - 0.10) < 0.001)
    }

    @Test func capsAtMaxPositionWhenStopIsTight() {
        // Entry 1000, stop 990 → risk/share 10. Risk-based shares = 43000. 43M position = 100% (over cap).
        // Cap: max position = 6.45M / 1000 = 6450 shares.
        let p = sizer.size(entry: 1000, stop: 990)!
        #expect(p.shares == 6450)
        #expect(p.positionValue == 6_450_000)
        #expect(abs(p.allocationPct - 0.15) < 0.001)
    }

    @Test func returnsNilWhenStopAtOrAboveEntry() {
        #expect(sizer.size(entry: 1000, stop: 1000) == nil)
        #expect(sizer.size(entry: 1000, stop: 1100) == nil)
    }

    @Test func returnsNilWhenEntryExceedsMaxPositionValue() {
        // Entry 10M, max position 6.45M → can't even afford one share within cap.
        #expect(sizer.size(entry: 10_000_000, stop: 9_000_000) == nil)
    }

    @Test func flooredSharesNeverOverdrawRisk() {
        // Entry 1233, stop 1100 → risk/share 133. 430k / 133 = 3233.08 → floor to 3233 shares.
        let p = sizer.size(entry: 1233, stop: 1100)!
        #expect(p.shares == 3233)
        // Sanity: total risk = 3233 × 133 = 429_989 ≤ 430_000.
        #expect(p.shares * 133 <= 430_000)
    }
}
