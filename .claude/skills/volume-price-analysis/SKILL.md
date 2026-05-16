---
name: volume-price-analysis
description: >
  Apply Anna Coulling's Volume Price Analysis (VPA) framework to interpret market
  behavior. Use this skill whenever the user asks about VPA, volume spread analysis,
  candlestick + volume interpretation, Wyckoff-based analysis, detecting smart money
  activity, identifying accumulation/distribution, anomalous volume candles, no-demand
  bars, stopping volume, upthrusts, or asks you to analyze a chart using volume and
  price together. Also trigger when the user provides OHLCV data and wants to read
  "what the market is saying." This skill encodes Coulling's complete analytical
  framework so always consult it before rendering any VPA-based interpretation.
---

# Volume Price Analysis — Anna Coulling Framework

A complete reference for applying Anna Coulling's VPA methodology, distilled from
*A Complete Guide to Volume Price Analysis* (2013). VPA reads price and volume
*together* — neither alone is sufficient.

---

## Core Philosophy

> "Volume is the fuel that moves markets. Price tells you where the market is going;
> volume tells you whether to believe it."

**The three questions to always ask:**
1. What is the candle body + spread (range) telling me?
2. What is the volume telling me — high, low, or average?
3. Do they *agree* or *disagree*?

Agreement → trend likely to continue.
Disagreement → potential reversal or pause. Investigate.

---

## Foundational Concepts

### Price Spread (Range)
- **Wide spread**: Strong conviction from the side in control.
- **Narrow spread**: Lack of conviction, equilibrium, or deliberate suppression.
- Spread is measured relative to *recent bars*, not absolute pips/points.

### Volume Calibration
Always compare current bar volume to the *recent 10–20 bar average* for context.
- **Ultra-high**: 2–3× average or more
- **High**: Noticeably above average
- **Average**: Unremarkable
- **Low**: Below average — signals disinterest
- **Ultra-low**: Extremely thin — signals no participation

### Candle Close Position
Where price closes *within* the spread matters enormously:
- **Upper third**: Buyers in control for that bar
- **Middle**: Contested, indecisive
- **Lower third**: Sellers in control for that bar

---

## The VPA Signal Library

### Bullish Signals

#### Stopping Volume (Selling Climax)
- **Setup**: Downtrend in progress
- **Bar**: Wide spread DOWN, ultra-high or high volume, closes in upper half
- **Meaning**: Professional money absorbing supply — sellers exhausted. Likely reversal.
- **Confirmation**: Next bar(s) narrow spread, low volume (no further selling pressure)

#### Test (after markup)
- **Setup**: After a confirmed up-move
- **Bar**: Narrow spread, low or ultra-low volume, closes in upper half or mid
- **Meaning**: Market "tests" for remaining supply — finding none. Professionals confirming the coast is clear.
- **Confirmation**: If market rises after test → bullish continuation

#### No Supply
- **Bar**: Narrow spread, LOW volume, in a downtrend or after pullback
- **Meaning**: Sellers stepping away — supply drying up. Not necessarily a reversal yet but precursor.
- **Context**: More significant near support or after stopping volume

#### Shakeout
- **Bar**: Wide spread DOWN, high volume, closes back UP (intrabar reversal)
- **Meaning**: False breakdown engineered by smart money to shake out weak hands and scoop cheap inventory
- **Confirmation**: Market turns up immediately after

#### Reverse Upthrust (Bullish variant)
- **Bar**: Down bar with narrow spread, low volume after a downtrend
- **Meaning**: Supply absorbed, downside momentum collapsing

---

### Bearish Signals

#### Upthrust
- **Setup**: After a rally or at resistance
- **Bar**: Wide spread UP, high volume, closes in LOWER half of spread or reverses next bar
- **Meaning**: False breakout — professional selling into retail buying. Trap.
- **Confirmation**: Market turns down next bar(s)

#### No Demand
- **Bar**: Narrow spread UP, low volume, in uptrend or bounce
- **Meaning**: Weak rally with no institutional participation — warning that the move has no backing
- **Confirmation**: If followed by a down bar on wider spread/higher volume → distribution confirmed

#### Distribution (Effort to Rise, No Result)
- **Bar**: Wide spread UP, ultra-high volume, closes in LOWER half
- **Meaning**: Smart money distributing (selling) into the rising price. Retail buying; professionals unloading.
- **Critical tell**: High effort (wide spread + high volume) but price *doesn't* advance → exhaustion

#### End of Rising Market
- **Bar**: Narrow spread, very high volume, near top of range — can be up or down bar
- **Meaning**: Volume anomaly at highs signals professionals offloading. Supply overwhelming demand.

---

### Neutral / Context Signals

#### Churn / Churning
- **Bar**: High to ultra-high volume, narrow spread, little net movement
- **Meaning**: Major battle between buyers and sellers. Often signals a turning point.
- **Direction depends on context**: At top → bearish; at bottom → bullish (accumulation)

#### Effort vs Result
Always ask: "Given the volume (effort), is the price move (result) proportional?"
- High volume + big move = in proportion → trend strength
- High volume + small move = out of proportion → absorption, reversal risk
- Low volume + big move = suspicious → unsupported, likely to fail

---

## Wyckoff Integration

Coulling's VPA is grounded in Wyckoff's principles. Key phases to identify:

| Phase | Characteristics |
|-------|----------------|
| **Accumulation** | Sideways price, high volume spikes (stopping/absorption), tests with low volume |
| **Markup** | Rising price, expanding volume on up-bars, low volume on pullbacks |
| **Distribution** | Sideways at highs, churning, no-demand bars, upthrusts |
| **Markdown** | Falling price, high volume on down-bars, no supply on bounces |

---

## Multi-Timeframe VPA Protocol

1. **Higher timeframe first** (e.g., Daily or Weekly): Determine primary trend phase
   (accumulation / markup / distribution / markdown)
2. **Intermediate timeframe** (e.g., 4H): Identify the swing context
3. **Entry timeframe** (e.g., 1H or 15m): Look for VPA confirmation signals to enter

Never trade a signal on a lower timeframe that contradicts the higher-timeframe phase.

---

## Step-by-Step Analysis Workflow

When given price + volume data or a chart description:

1. **Identify the trend** on the chart (up, down, sideways)
2. **Locate anomalous volume bars** (unusually high or low relative to recent average)
3. **For each anomaly**: classify candle spread and close position
4. **Match to signal library** above
5. **Apply effort vs result test**
6. **Check context**: Is this at support/resistance? Near highs/lows? After a long trend?
7. **Look for confirmation**: Next 1–3 bars should reinforce or negate the signal
8. **State conclusion**: What are the professionals likely doing here?

---

## Common Mistakes to Avoid

| Mistake | Correction |
|---------|------------|
| Reading volume in isolation | Always pair with spread + close position |
| Using absolute volume thresholds | Calibrate relative to *recent* bars |
| Ignoring context (trend phase) | A no-demand bar in accumulation ≠ no-demand bar in markdown |
| One-bar conclusions | Require confirmation from subsequent bar(s) |
| Assuming high volume = bullish | High volume on a down bar closing low = bearish absorption |
| Ignoring the close position | A wide up bar closing at the low is NOT bullish |

---

## Quick Reference Cheat Sheet

```
Signal            | Spread | Volume | Close  | Context    | Bias
------------------|--------|--------|--------|------------|-------
Stopping Volume   | Wide ↓ | High   | Upper  | Downtrend  | Bull
Test              | Narrow | Low    | Mid/Up | After up   | Bull
No Supply         | Narrow | Low    | Any    | Pullback   | Bull
Shakeout          | Wide ↓ | High   | Reverses| Support   | Bull
Upthrust          | Wide ↑ | High   | Lower  | Resistance | Bear
No Demand         | Narrow | Low    | Up     | Uptrend    | Bear
Distribution      | Wide ↑ | High   | Lower  | Near top   | Bear
Churn (top)       | Narrow | High   | Mid    | At highs   | Bear
Churn (bottom)    | Narrow | High   | Mid    | At lows    | Bull
```

---

## Output Format for VPA Analysis

When producing a VPA analysis, always structure it as:

1. **Trend Context**: What phase is the market in on this timeframe?
2. **Key Volume Events**: List anomalous bars chronologically with their VPA classification
3. **Effort vs Result Summary**: Is volume confirming or contradicting price action?
4. **Likely Smart Money Behavior**: Accumulating? Distributing? Testing? Trapping?
5. **Bias**: Bullish / Bearish / Neutral with confidence level (low/medium/high)
6. **What to Watch**: What confirmation signals would strengthen or invalidate this read?

---

## References

- Coulling, Anna. *A Complete Guide to Volume Price Analysis*. 2013.
- Wyckoff, Richard. *Studies in Tape Reading*. 1910.
- Core Wyckoff concepts: Composite Man, Cause & Effect, Effort vs Result, Supply & Demand

---

## IDX Screener — Coulling Stopping Volume

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

**Entry timing**: Early-Mid (Wyckoff Phase C / D pivot) — climactic reversal. Route from `institutional-flow` universe.
