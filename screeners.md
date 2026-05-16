# IDX Trading Screeners — One Per Trading Skill

Each screener uses **only** metrics available in the `Add Financial Metric` list. IDX (Bursa Efek Indonesia) context assumed. 8 remaining trading skills → 8 screeners.

---

## 1. `institutional-flow` — Confluence Universe Filter

**Intent**: Stage 1+2 of the 4-stage funnel — liquid IDX names with smart-money tailwind in a healthy trend.

| Filter | Operator | Value |
|---|---|---|
| Value MA 20 | > | 5,000,000,000 (5B IDR — liquidity floor) |
| Price MA 50 | > | Price MA 200 |
| Price | > | Price MA 20 |
| 1 Month Net Foreign Flow | > | 0 |
| Bandar Value MA 10 | > | Bandar Value MA 20 |
| Net Insider Buy / Sell (6M) (%) | > | 0 |
| RSI (14) | between | 40 and 70 |

**Invalidation**: Price closes below Price MA 50.

---

## 2. `bandarmology` — Quiet Bandar Accumulation

**Intent**: Bandar accumulating before markup — value rising, frequency quiet, foreign aligned.

| Filter | Operator | Value |
|---|---|---|
| Bandar Accum/Dist | > | 0 |
| Bandar Value | > | Bandar Value MA 20 |
| Bandar Value MA 10 | > | Bandar Value MA 20 |
| Net Foreign Buy Streak | >= | 3 |
| 1 Month Net Foreign Flow | > | 0 |
| Frequency | < | Frequency Analyzer MA 50 |
| Value | > | Value MA 20 |

**Invalidation**: Bandar Accum/Dist flips negative or Net Foreign Sell Streak >= 2.

---

## 3. `chart-patterns` — Bulkowski BB Squeeze → Breakout

**Intent**: Tight Bollinger range → breakout with volume confirmation (highest-probability Bulkowski setup family).

| Filter | Operator | Value |
|---|---|---|
| (BB Upper 20 − BB Lower 20) / Price MA 20 | < | 0.10 *(squeeze)* |
| Price | > | Bollinger Band Upper (20) |
| Volume | > | 2 × Volume MA 20 |
| 1 Day Volume Change | > | 50% |
| Price | > | Price MA 50 |

**Target proxy**: prior BB range height projected from breakout. **Invalidation**: close back inside BB.

---

## 4. `grimes-technical-analysis` — With-Trend Pullback (Statistical Edge)

**Intent**: Grimes's bread-and-butter — pullback inside an established trend on falling volume, then re-entry.

| Filter | Operator | Value |
|---|---|---|
| Price MA 20 | > | Price MA 50 |
| Price MA 50 | > | Price MA 200 |
| Price | between | Price MA 10 and Price MA 20 |
| RSI (14) | between | 40 and 55 |
| Stochastic (14,1,3) | < | 30 |
| Volume | < | Volume MA 20 |

**Edge**: low-vol pullback in stacked-MA trend has statistically positive expectancy.

---

## 5. `reminiscences-stock-operator` — Livermore Pivotal Point

**Intent**: Line of least resistance breaking upward on conviction volume — Livermore's "leaders" thesis.

| Filter | Operator | Value |
|---|---|---|
| Price | > | Bollinger Band Upper (20) |
| Price | > | Price MA 200 |
| Price MA 20 | > | Price MA 50 |
| Volume | > | Volume MA 50 |
| Value | > | Value MA 50 |
| 1 Day Volume Change | > | 30% |
| Net Foreign Buy / Sell | > | 0 |

**Invalidation**: failure of pivotal point — close back below Price MA 20 within 3 bars.

---

## 6. `technical-analysis-murphy` — Classical Trend-Follower

**Intent**: Murphy's textbook stack — MA alignment + momentum confirmation.

| Filter | Operator | Value |
|---|---|---|
| Price MA 50 | > | Price MA 200 *(golden-cross regime)* |
| Price | > | Price MA 50 |
| MACD (12,26) | > | 0 |
| RSI (14) | > | 50 |
| Stochastic (14,1,3) | between | 50 and 80 |
| Volume MA 20 | > | Volume MA 50 |

**Invalidation**: MACD crosses zero down, or Price MA 50 < Price MA 200.

---

## 7. `volume-price-analysis` — Coulling Stopping Volume

**Intent**: Climactic down-volume rejected — classic VPA stopping-volume / spring tail with smart money present.

| Filter | Operator | Value |
|---|---|---|
| Low Price | < | Price MA 20 |
| Price | > | Open Price *(bullish close on the test)* |
| Volume | > | 2 × Volume MA 20 |
| 1 Day Volume Change | > | 100% |
| Foreign Flow MA 20 | > | 0 |
| Frequency Spike | = | true |

**Invalidation**: next bar closes below the stopping-volume bar's low.

---

## 8. `wyckoff-2` — Phase C Spring

**Intent**: Penetrate support, reject back inside, climactic volume, composite man (bandar) buying — textbook Wyckoff 2.0 spring.

| Filter | Operator | Value |
|---|---|---|
| Low Price | < | Bollinger Band Lower (20) *(penetration)* |
| Price | > | Bollinger Band Lower (20) *(rejection / closed back in)* |
| Price | > | Open Price |
| Volume | > | 2 × Volume MA 50 |
| Bandar Value | > | 0 |
| Bandar Accum/Dist | > | 0 |
| Net Foreign Buy Streak | >= | 2 |
| RSI (14) | < | 40 |

**Invalidation**: subsequent close below the spring low → not a spring, treat as breakdown.

---

## Suggested Workflow

1. Run **#1 `institutional-flow`** as the daily universe filter.
2. Route survivors to the lens matching current market context:
   - **IDX bandar plays** → #2
   - **Trend continuation** → #4, #6
   - **Breakouts** → #3, #5
   - **Reversal / accumulation** → #7, #8
3. Require **at least 2 concurrent screener hits** before adding to watchlist (confluence).

---

# Entry vs Exit Decisions

All 8 screeners above are **entry/setup detectors**. Different `#1 → X` routings give you different *entry timings*. Exits are governed by each screener's **invalidation rule**, not a separate screener.

## Entry Timing by Route

| Route | Setup type | Entry timing | Wyckoff cycle position |
|---|---|---|---|
| `#1 → #8` Wyckoff Spring | Reversal at bottom | **Earliest** | Phase C (accumulation) |
| `#1 → #2` Bandar Accumulation | Stealth accumulation | **Early** | Phase B / early C |
| `#1 → #7` VPA Stopping Volume | Climactic reversal | **Early-Mid** | Phase C / D pivot |
| `#1 → #3` BB Squeeze Breakout | Range release | **Mid (transition)** | Phase D start (markup begins) |
| `#1 → #4` Grimes Pullback | Continuation re-entry | **Mid** | Phase D markup |
| `#1 → #6` Murphy Trend | Trend confirmation | **Mid-Late** | Phase D markup |
| `#1 → #5` Livermore Pivot | Momentum breakout | **Latest** | Late Phase D (leaders) |

**Risk/reward trade-off**: earlier entry (#8, #2) = bigger R:R but lower hit rate. Later entry (#5, #6) = smaller R:R but higher confirmation.

## Exit Logic — Use Invalidation per Position

Exits are position-specific (tied to where you entered), so they belong on alerts rather than a daily scan:

| Entry from | Exit trigger (from the screener's invalidation) |
|---|---|
| #2 Bandarmology | Bandar Accum/Dist < 0 **or** Net Foreign Sell Streak >= 2 |
| #3 BB Breakout | Close back inside BB Upper (20) |
| #4 Grimes Pullback | Close < Price MA 50 |
| #5 Livermore Pivot | Close < Price MA 20 within 3 bars |
| #6 Murphy Trend | MACD < 0 **or** Price MA 50 < Price MA 200 |
| #7 VPA Stopping Vol | Close < the stopping-volume bar's Low |
| #8 Wyckoff Spring | Close < spring's Low |

## Portfolio-Wide Exit Sweep (Optional Mirror Screener)

Run nightly across all open positions — any hit = trim/exit regardless of which entry screener got you in.

**Distribution / Exit Watchlist**

| Filter | Operator | Value |
|---|---|---|
| Bandar Accum/Dist | < | 0 |
| Bandar Value MA 10 | < | Bandar Value MA 20 |
| Net Foreign Sell Streak | >= | 3 |
| 1 Week Net Foreign Flow | < | 0 |
| Price | < | Price MA 20 |
| MACD (12,26) | < | 0 |

---

**TL;DR**: `#1 → anything` = **entry** (varying timing). **Exits** = invalidation line on each open position, monitored as alerts. The mirror distribution screener above is optional for portfolio-wide exit sweeps.
