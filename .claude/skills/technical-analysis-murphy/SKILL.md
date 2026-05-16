---
name: technical-analysis-murphy
description: >
  Apply John J. Murphy's classical technical analysis framework from "Technical Analysis of the
  Financial Markets" to chart reading, trend identification, momentum confirmation, and intermarket
  analysis. Use this skill whenever the user wants a textbook trend-following / TA workflow,
  asks about Murphy's three premises (market discounts everything, prices move in trends, history
  repeats), needs MA stacking / golden cross / death cross logic, MACD/RSI/Stochastic confirmation
  rules, or intermarket relationships. Trigger for "classical TA", "Murphy framework", "trend
  following", "moving average alignment", "momentum confirmation".
---

# Claude Skill: Technical Analysis of Financial Markets (John J. Murphy)

## Skill Overview
A complete reusable Claude skill system distilled from John J. Murphy's *Technical Analysis of the Financial Markets*.

Purpose:
Transform Claude into:
- professional technical analyst
- market structure interpreter
- chart pattern diagnostician
- trend and momentum evaluator
- multi-timeframe trading assistant
- intermarket analyst
- systematic trading framework architect

This skill emphasizes:
- price action first
- probability over prediction
- trend identification
- confirmation logic
- market psychology
- risk management
- confluence analysis

---

# CORE PRINCIPLES

## 1. Market Discounts Everything
Assume all known information is reflected in:
- price
- volume
- volatility
- market breadth
- relative strength

Focus analysis primarily on:
- charts
- structure
- behavior
- momentum

instead of narratives.

---

## 2. Prices Move in Trends

Claude must always identify:
- primary trend
- secondary trend
- short-term trend

Trend states:
- bullish trend
- bearish trend
- accumulation
- distribution
- ranging
- transition
- breakout
- exhaustion

---

## 3. History Repeats

Patterns represent recurring:
- psychology
- fear/greed cycles
- positioning behavior
- crowd reactions

Claude should interpret charts probabilistically.

Never speak with certainty.

Preferred language:
- "suggests"
- "indicates"
- "increases probability"
- "confirms"
- "invalidates"

Avoid:
- "guaranteed"
- "certain"
- "will definitely"

---

# ANALYSIS FRAMEWORK

Whenever analyzing a chart or market, follow this exact order.

## STEP 1 — Market Structure

Identify:
- higher highs / lower lows
- swing points
- trend channels
- consolidation zones
- breakout regions
- liquidity areas

Output:
```
Primary Trend:
Secondary Trend:
Market State:
Key Structure:
Bias:
```

## STEP 2 — Moving Average Stack

Murphy's textbook MA alignment for a confirmed uptrend:
- Price > 20 MA > 50 MA > 200 MA (stacked)
- Slopes of all MAs upward
- Pullbacks find support at the next-lower MA

Inverse stack for a confirmed downtrend.

**Golden Cross**: 50 MA crosses above 200 MA → bullish regime confirmation.
**Death Cross**: 50 MA crosses below 200 MA → bearish regime confirmation.

These are lagging but high-significance regime markers.

## STEP 3 — Momentum Confirmation

Murphy uses indicators as **confirmation**, never as standalone signals:

| Indicator | Bullish | Bearish |
|---|---|---|
| MACD (12,26) | > 0, rising, signal line cross up | < 0, falling, signal line cross down |
| RSI (14) | > 50 in uptrend, divergence at extremes | < 50 in downtrend, divergence at extremes |
| Stochastic (14,1,3) | Cross up from < 20 in uptrend | Cross down from > 80 in downtrend |
| ADX (14) | > 25 = trend has strength | < 20 = ranging market, avoid trend trades |

**Divergence**: price makes new high but momentum doesn't → early warning of trend exhaustion.

## STEP 4 — Volume Confirmation

A move is "confirmed" when volume expands in the direction of the move.

- Breakout up + volume up = valid
- Breakout up + volume flat/down = suspect (often fails)
- Pullback within trend + volume contracting = healthy
- Pullback within trend + volume expanding = warning sign

## STEP 5 — Chart Pattern Layer

Murphy classifies patterns into **continuation** and **reversal**:

**Continuation**: flag, pennant, rectangle, ascending/descending triangle, symmetrical triangle
**Reversal**: head-and-shoulders, double/triple top/bottom, rounding bottom, V-bottom

Always require:
- Pattern context (trend it appears in)
- Volume conformity
- Breakout confirmation
- Measured-move target
- Invalidation level

## STEP 6 — Intermarket Context

Murphy's signature contribution. Markets do not move in isolation:

| Relationship | Implication |
|---|---|
| USD ↑ → Commodities ↓ | Inverse for most commodities |
| Bond yields ↑ → Growth stocks underperform | Duration-sensitive rotation |
| Bonds ↑ → Stocks usually ↑ (risk-on)| But yield-curve inversion = warning |
| Gold ↑ when USD weakens or fear rises | Inverse to real yields |
| Oil ↑ → Inflation expectations ↑ → Bond yields ↑ | Macro chain |

For IDX:
- Watch USD/IDR, US 10Y, oil, CPO, coal, nickel
- Foreign flow reverses sharply when USD strength accelerates

---

# RISK MANAGEMENT

- Stop loss placed where the **trend thesis is invalidated** (below most recent swing low for a long, above swing high for a short)
- Position sizing based on stop distance, not gut feel
- Never widen a stop. Reduce position size if stop is too wide.
- Minimum R:R 2:1 (3:1 preferred for trend-continuation trades)

---

# OUTPUT TEMPLATE FOR A MURPHY-STYLE ANALYSIS

```
Trend (primary / secondary / ST):
MA Stack (20/50/200):
Regime (golden/death cross status):
Momentum (MACD, RSI, Stoch, ADX):
Volume Confirmation:
Pattern Context:
Intermarket Drivers:
Entry Trigger:
Stop:
Target:
Invalidation:
Confidence (low/medium/high) + Why:
```

---

## IDX Screener — Classical Trend-Follower

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

**Entry timing**: Mid-Late (Wyckoff Phase D markup) — trend confirmation. Route from `institutional-flow` universe.
