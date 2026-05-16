---
name: grimes-technical-analysis
description: >
  Apply Adam Grimes' framework from "The Art and Science of Technical Analysis" to market analysis,
  trade planning, and chart reading. Use this skill whenever the user wants to analyze price charts,
  identify patterns with statistical edge, assess trend structure, evaluate trade setups, manage risk,
  or critique whether a pattern or signal has genuine probabilistic backing. Trigger this skill when
  the user asks about technical analysis in any serious context — including IDX stocks, crypto, or
  forex — especially when they want rigorous, data-driven TA rather than pattern-matching folklore.
  Also trigger for questions about trading psychology, market structure, support/resistance validity,
  or whether a specific indicator or strategy "works."
---

# Grimes Technical Analysis Skill

Based on *The Art and Science of Technical Analysis* by Adam Grimes. This framework treats TA as a
probabilistic, statistically-grounded discipline — not a pattern-matching art form. The central thesis:
most published patterns do not have verifiable edge; only a small subset of setups, rigorously applied
with disciplined risk management, can produce consistent profitability.

---

## Core Philosophy

### The Edge Concept
- **Edge** = a statistically verifiable advantage over random entry. Without edge, no position sizing
  or money management can produce long-term profitability.
- Most candlestick patterns, classical chart patterns, and indicator signals have been shown to have
  **no reliable edge** when tested over large datasets. Grimes is explicit and blunt about this.
- Edge comes from: trend structure, supply/demand imbalances, and behavioral tendencies of market
  participants — not from geometric pattern shapes alone.

### The Market as a Random Walk (With Departures)
- Markets are largely efficient and random. Profitable TA exploits the **non-random departures**
  from this baseline.
- Three primary sources of non-randomness:
  1. **Trend persistence** — trending markets tend to continue trending
  2. **Mean reversion** in ranging markets at extremes
  3. **Volatility clustering** — calm periods follow calm, volatile follow volatile

### Statistical Thinking
- Every trade setup should be evaluated as a **probability distribution**, not a certainty.
- Avoid outcome bias: a winning trade does not validate a bad process; a losing trade does not
  invalidate a good one.
- Think in terms of **expected value (EV)**: `EV = (Win Rate × Avg Win) - (Loss Rate × Avg Loss)`

---

## Market Structure Analysis

### Trend Identification
Grimes' trend framework is structural, not indicator-based:

**Uptrend structure:**
- Series of higher highs (HH) and higher lows (HL)
- Pullbacks shallow relative to impulse legs
- Price spends more time above a rising moving average (e.g., 20 EMA)

**Downtrend structure:**
- Series of lower lows (LL) and lower highs (LH)
- Rallies fail at prior resistance levels

**Range / Consolidation:**
- Roughly equal highs and lows
- Price oscillates between defined support and resistance
- Breakouts from ranges often fail — treat with skepticism until confirmed

**Key principle:** Identify the trend on a *higher timeframe* before executing on a lower one.
Always trade in the direction of the dominant trend unless mean-reversion setup has explicit edge.

### Support and Resistance
- S/R is a **zone**, not a line. Treating it as a precise number is a common amateur mistake.
- S/R derives from: prior swing highs/lows, consolidation zones, round numbers (psychological),
  and areas of high-volume activity.
- **Former resistance becomes support** (and vice versa) — but only probabilistically. This "flip"
  fails often enough that tight stops are still required.
- Grimes warns against overconfidence in S/R; price does not "respect" levels — market participants
  react around them due to anchoring bias.

### Moving Averages
- Not predictive. Used to **define trend regime** and identify where price is relative to average
  cost basis.
- Recommended: 20-period EMA (short-term trend), 50-period EMA (intermediate), 200-period SMA
  (long-term institutional reference).
- Moving average crossovers alone have negative or near-zero EV after costs. Never use in isolation.

---

## Pattern Analysis

### The Problem with Most Patterns
Grimes' most controversial (and well-supported) argument: the majority of named chart patterns
(head and shoulders, triangles, flags, cup-and-handle, etc.) **do not have statistically significant
edge** when tested rigorously across large samples.

Why patterns "work" in hindsight but fail in testing:
- **Confirmation bias** — traders remember the winners
- **Lookahead bias** in backtests — patterns are easier to identify after the outcome
- **Ambiguous definitions** — a "flag" can be drawn many ways depending on the desired conclusion

### Patterns That DO Show Edge (Grimes' View)
These are not "always profitable" but show statistically meaningful tendencies when traded correctly:

1. **Anti-trend pullbacks (retracements into trend)**
   - Price pulls back to a moving average or S/R zone within a clear trend
   - Enter when momentum shows signs of resumption (not during the pullback itself)
   - Best edge: pullback is shallow, volume contracts during pullback

2. **Failed breakouts (fakeouts)**
   - Price breaks a clearly-defined level, triggers stops, then reverses
   - "Trap" move: lures breakout traders, then reverses sharply
   - High EV setup — good R:R, defined entry/stop

3. **Momentum breakouts with consolidation**
   - Price consolidates tightly after a strong trend move, then breaks in trend direction
   - Requires volatility contraction before the break (narrowing range)
   - Valid only if the broader trend is intact

4. **Tested and held levels**
   - A S/R level that has been tested multiple times and held is stronger than a first-touch level
   - BUT: too many tests can weaken a level (absorption of resting orders)

### Pattern Evaluation Checklist
Before trading any pattern, ask:
- [ ] Is this pattern defined objectively enough to be tested?
- [ ] Does this pattern have documented edge, or am I relying on folklore?
- [ ] Is the broader market trend aligned with the direction of this trade?
- [ ] Where is the stop loss? Is it logical (just beyond the pattern's invalidation point)?
- [ ] What is the realistic target? Does R:R ≥ 2:1?
- [ ] Am I entering at a good point within the setup, or chasing?

---

## Trade Planning Framework

### The Three-Part Setup
Every trade should have:
1. **Reason to be in the market** — structural logic based on trend + pattern with edge
2. **Defined risk** — stop loss placed at a level that invalidates the thesis, not arbitrary
3. **Defined target** — based on structure (prior swing, S/R zone), not wishful thinking

### Entry Timing
- **Do not enter at the beginning of a move** if you haven't confirmed the setup.
- Patience: wait for price to *come to you* — enter at the pullback, not the breakout impulse.
- Exception: momentum breakouts can be entered on the break candle's close with tight stop.

### Stop Loss Principles
- Stop goes where the **trade thesis is invalidated**, not where your risk tolerance is.
- Stop below the swing low (long) or above the swing high (short) that defines the setup.
- Never widen a stop because price is approaching it. That is hope management, not risk management.
- If the stop is too wide for your account size, reduce position size — do not tighten the stop
  to fit the position.

### Position Sizing
- Risk per trade = fixed % of account (Grimes recommends starting at 0.5–1% for new traders).
- `Position Size = (Account × Risk%) / (Entry Price - Stop Price)`
- Consistent position sizing is more important than which % you choose. Consistency enables
  statistical learning from your trade log.

### Reward-to-Risk (R:R)
- Minimum viable R:R: **2:1**. Many professional setups target 3:1 or higher.
- R:R is not a magic formula — it interacts with win rate: a 40% win rate with 3:1 R:R is
  highly profitable; a 60% win rate with 1:1 R:R is break-even before costs.
- Do not force targets. If structure doesn't support a 2:1 target, skip the trade.

---

## Indicators — Grimes' View

Grimes is skeptical but not dismissive. Key principles:

| Indicator | Grimes' Assessment |
|---|---|
| RSI / Stochastic | Overbought/oversold signals have poor edge in trending markets. More useful as divergence tool |
| MACD | Lagging. Crossovers have near-zero edge. Useful for regime identification only |
| Bollinger Bands | Mean reversion signals at bands fail often in trends. Better as volatility context |
| Volume | Most useful indicator. Confirms or questions price moves. Low-volume breakouts suspect |
| ATR | Excellent for position sizing and stop placement. Not a signal, a measurement |

**Rule:** Never use an indicator as a standalone signal. Use as **confluence** with structure.

---

## Psychology and Behavioral Edge

### Why Traders Fail (Even With Good Systems)
1. **Inconsistent execution** — skipping setups, moving stops, exiting early
2. **Outcome-based feedback loops** — adjusting strategy based on too-small sample sizes
3. **Overconfidence after wins, fear after losses** — both distort judgment

### Grimes' Psychological Framework
- Trade a **process**, not a result. Evaluate yourself on adherence to rules, not P&L of a single trade.
- Keep a **trade journal** with: setup type, entry rationale, planned stop/target, actual execution,
  outcome, and self-assessment of adherence to process.
- After a losing streak: review for **process errors**, not pattern errors. If the process was correct,
  the losses are expected variance — do not change the system.
- After a winning streak: beware overconfidence. Size stays the same; the edge hasn't increased.

### Cognitive Biases to Monitor
- **Recency bias** — recent trades distort assessment of long-run expectancy
- **Anchoring** — prior prices bias where you think price "should" go
- **Loss aversion** — holding losers too long, cutting winners too early (the disposition effect)
- **Narrative fallacy** — constructing a story to explain a trade rather than a statistical thesis

---

## Practical Workflow: Analyzing a Setup

Use this sequence when evaluating any potential trade:

### Step 1: Timeframe Alignment
- Identify trend on 1 level higher than your trading timeframe
- Weekly → defines bias for daily trades
- Daily → defines bias for intraday trades
- Only trade setups aligned with the higher-timeframe trend (or explicit mean-reversion logic)

### Step 2: Structure Assessment
- Mark key swing highs/lows on the trading timeframe
- Is price in a trend or range?
- Where are the key S/R zones relevant to the current price location?

### Step 3: Pattern/Setup Identification
- Does a pattern with known edge exist at this location?
- Is it at a meaningful structural level (not random mid-range)?
- Does volume behavior support the setup?

### Step 4: Risk Definition
- Where exactly does the stop go? (specific price level, not "below support roughly")
- What is the position size given this stop and your account risk %?

### Step 5: Target Assessment
- What is the first logical structural target?
- What is the R:R at that target?
- If R:R < 2:1, is there a secondary target that justifies the trade?

### Step 6: Decision
- Take the trade, pass, or set an alert for a better entry point.
- Document the reasoning regardless of outcome.

---

## Common Mistakes and Grimes' Corrections

| Common Mistake | Grimes' Correction |
|---|---|
| "This pattern always works" | No pattern always works. Ask: what's the documented win rate and EV? |
| Using indicators to confirm indicators | Indicators are derived from price. Multiple indicators aren't independent data |
| Trading against the trend because it "looks stretched" | Trends persist longer than intuition expects. Don't short strength without structural reversal signals |
| Buying breakouts at resistance | Many breakouts fail. Better entry: wait for a pullback that holds former resistance |
| Widening stops to "give the trade room" | This changes the R:R and invalidates the original setup logic |
| Averaging down into a loser | You're adding risk when your thesis has already been partially invalidated |

---

## Application to Indonesian IDX Context

- **Liquidity caveat**: Grimes' framework was developed on liquid US markets. On IDX, many stocks
  have thin liquidity — patterns are more susceptible to manipulation (bandarmology). Apply
  additional skepticism to pattern signals in stocks with market cap < IDR 1T.
- **Trend-following setups** (pullback in trend) apply well to IDX blue-chips (BBCA, TLKM, ASII, etc.)
- **Breakout setups** require volume confirmation more critically on IDX due to wider spreads and
  operator-driven moves.
- **Failed breakout / fakeout** setups are particularly common on IDX due to retail stop clusters
  being hunted by larger operators. This setup may have *enhanced* edge on IDX relative to US markets.
- Combine Grimes' structural approach with your bandarmology/broker flow analysis for IDX:
  broker flow confirms "who is accumulating," Grimes' structure tells you *when* to act.

---

## Quick Reference: Setup Validity Test

Answer YES to all before entering:
1. Is the trend direction on the higher timeframe aligned with this trade?
2. Is the setup at a meaningful structural location (not random mid-range)?
3. Is there a defined stop level that invalidates the thesis?
4. Is R:R ≥ 2:1 to the first structural target?
5. Does volume behavior support (or at least not contradict) the setup?
6. Am I entering at an efficient point — not chasing a move already underway?

If any answer is NO → pass or wait for a better setup. There is always another trade.
