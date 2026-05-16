---
name: institutional-flow
description: >
  IDX 4-stage funnel universe filter and exit-sweep methodology. Use this skill as the
  Stage 1+2 daily universe screen — liquid IDX names with smart-money tailwind in a healthy
  trend — before routing survivors to any of the 7 entry-style skills (bandarmology,
  wyckoff-2, volume-price-analysis, chart-pattern-encyclopedia, grimes-technical-analysis,
  technical-analysis-murphy, reminiscences-stock-operator). Trigger this skill when the user
  asks about: confluence filtering, IDX daily watchlist construction, the 4-stage funnel,
  exit/distribution sweep, portfolio-wide trim alerts, entry-timing routing by Wyckoff phase,
  or "which screener should I run first?".
---

# Institutional Flow — IDX Confluence Funnel

The first two stages of the 4-stage funnel. Filters the IDX universe down to liquid names
with smart-money tailwind in a healthy trend, before any entry-style screener (Wyckoff
Spring, Bandar Accumulation, VPA Stopping Volume, BB Squeeze Breakout, Grimes Pullback,
Murphy Trend, Livermore Pivot) is applied.

This skill is the **gateway**. Other skills are routes.

---

## Stage 1+2 Universe Screener

**Intent**: Liquid IDX names with smart-money tailwind in a healthy trend.

| Filter | Operator | Value |
|---|---|---|
| Value MA 20 | > | 5,000,000,000 (5B IDR — liquidity floor) |
| Price MA 50 | > | Price MA 200 |
| Price | > | Price MA 20 |
| 1 Month Net Foreign Flow | > | 0 |
| Bandar Value MA 10 | > | Bandar Value MA 20 |
| Net Insider Buy / Sell (6M) (%) | > | 0 |
| RSI (14) | between | 40 and 70 |

**Invalidation (regime-level)**: Price closes below Price MA 50.

---

## Suggested Daily Workflow

1. Run **`institutional-flow`** as the daily universe filter.
2. Route survivors to the lens matching current market context:
   - **IDX bandar plays** → `bandarmology`
   - **Trend continuation** → `grimes-technical-analysis`, `technical-analysis-murphy`
   - **Breakouts** → `chart-pattern-encyclopedia`, `reminiscences-stock-operator`
   - **Reversal / accumulation** → `volume-price-analysis`, `wyckoff-2`
3. Require **at least 2 concurrent screener hits** before adding to watchlist (confluence).

---

## Entry Timing by Route

All 7 entry-style skills are **entry/setup detectors**. Each route gives a different
*entry timing* on the Wyckoff cycle. Exits are governed by each route's invalidation rule.

| Route | Setup type | Entry timing | Wyckoff cycle position |
|---|---|---|---|
| `institutional-flow → wyckoff-2` | Reversal at bottom | **Earliest** | Phase C (accumulation) |
| `institutional-flow → bandarmology` | Stealth accumulation | **Early** | Phase B / early C |
| `institutional-flow → volume-price-analysis` | Climactic reversal | **Early-Mid** | Phase C / D pivot |
| `institutional-flow → chart-pattern-encyclopedia` | Range release | **Mid (transition)** | Phase D start (markup begins) |
| `institutional-flow → grimes-technical-analysis` | Continuation re-entry | **Mid** | Phase D markup |
| `institutional-flow → technical-analysis-murphy` | Trend confirmation | **Mid-Late** | Phase D markup |
| `institutional-flow → reminiscences-stock-operator` | Momentum breakout | **Latest** | Late Phase D (leaders) |

**Risk/reward trade-off**: earlier entry (`wyckoff-2`, `bandarmology`) = bigger R:R but lower
hit rate. Later entry (`reminiscences-stock-operator`, `technical-analysis-murphy`) = smaller
R:R but higher confirmation.

---

## Exit Logic — Per-Position Invalidation

Exits are position-specific (tied to where you entered), so they belong on alerts rather
than a daily scan:

| Entry from | Exit trigger (the route's invalidation) |
|---|---|
| `bandarmology` | Bandar Accum/Dist < 0 **or** Net Foreign Sell Streak >= 2 |
| `chart-pattern-encyclopedia` | Close back inside BB Upper (20) |
| `grimes-technical-analysis` | Close < Price MA 50 |
| `reminiscences-stock-operator` | Close < Price MA 20 within 3 bars |
| `technical-analysis-murphy` | MACD < 0 **or** Price MA 50 < Price MA 200 |
| `volume-price-analysis` | Close < the stopping-volume bar's Low |
| `wyckoff-2` | Close < spring's Low |

---

## Portfolio-Wide Exit Sweep (Optional Mirror Screener)

Run nightly across all open positions — any hit = trim/exit regardless of which entry
screener got you in.

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

## TL;DR

- `institutional-flow → <any route>` = **entry** (varying timing on the Wyckoff cycle).
- **Exits** = each route's invalidation line, monitored per-position as alerts.
- The mirror distribution screener above is optional for portfolio-wide exit sweeps.
- **Confluence rule**: require ≥2 concurrent route hits on the same name before adding to
  the watchlist.
