# Nemonic

A macOS menu-bar utility that watches `~/Desktop` for Stockbit screener screenshots, runs Apple Vision OCR on them, and emits structured JSON per screener type. Built in Swift / SwiftUI for macOS 14+.

## What it does

1. A `DispatchSource` watcher tails `~/Desktop` for new `Screenshot *.png` files.
2. Each PNG is OCR'd with Vision's `RecognizeDocumentsRequest` and `RecognizeTextRequest` in parallel.
3. The page title is matched against a registry of screener aliases (`ScreenerClassifier`).
4. Rows are mapped against the screener's column schema (loaded from bundled `sample-*.json`), filtered for OCR noise (sidebar/menu/footer junk), and written to `~/Desktop/<screener-id>.json`.
5. On success the source PNG is moved to the Trash. On no-match / no-table / no-rows the PNG is left in place.
6. A `SignalEngine` + `PositionSizer` annotate the result with a buy trigger and suggested allocation, surfaced in the menu-bar popover log.

Sandbox is off; the app is a `MenuBarExtra` agent (`LSUIElement=YES`).

## Project layout

```
Nemonic/
  NemonicApp.swift          @main, wires registry → coordinator → watchlist
  Domain/                   pure value types (schemas, signals, JSON model)
  Services/                 watcher, OCR, classifier, row mapper, JSON writer, file sink
  UI/                       MenuBarContentView
  Resources/sample-*.json   per-screener column schemas
NemonicTests/               XCTest unit tests
NemonicUITests/             XCUITest UI tests
scripts/                    build & packaging scripts
spec.md                     current state of work / open items
screeners.md                screener catalog notes
```

## Build & run

Open `Nemonic.xcodeproj` in Xcode and run the `Nemonic` scheme. The menu-bar icon (viewfinder) appears in the system bar; opening it auto-starts the watcher.

CLI build:

```sh
xcodebuild -project Nemonic.xcodeproj -scheme Nemonic -configuration Debug build
```

## Tests

```sh
xcodebuild test -project Nemonic.xcodeproj -scheme Nemonic -destination 'platform=macOS'
```

Currently 26 unit tests + 4 UI tests pass. Coverage areas: numeric value parser, JSON writer, screener registry, classifier, row mapper.

**TDD is the default for new behavior** — see `CLAUDE.md`. Write a failing test first; characterization tests before changing untested code.

## Packaging a dev DMG

Unsigned, ad-hoc–signed DMG for local sharing:

```sh
scripts/build-dev-dmg.sh           # versions by today's date
scripts/build-dev-dmg.sh 0.3.0     # explicit version
```

Output lands in `build/dist/Nemonic-<version>-dev.dmg`. Because it isn't notarized, recipients must right-click → Open the first launch, or strip the quarantine attribute:

```sh
xattr -dr com.apple.quarantine /Applications/Nemonic.app
```

## Parser contract (cell-level)

From `NumericValueParser` + tests:

| Input cell                  | Output                |
| --------------------------- | --------------------- |
| empty, `-`, `—`             | `""`                  |
| pure digits, optional `,`   | `.int` (`8,973,753,750` → `8973753750`) |
| contains `.`, `%`, `(`, `)`, or a letter | `.string`, whitespace-stripped (`26.79 B` → `"26.79B"`, `(424.38 B)` → `"(424.38B)"`, `60.25%` → `"60.25%"`) |
| first cell of every row     | always `.string` (ticker) |

Known limitation: sign encoded only by color (red `%`) is lost — OCR must surface a textual `-` for negatives.

## Adding a screener

1. Drop a `sample-<id>.json` into `Nemonic/Resources/` with the desired key order and example values.
2. Add aliases for the screener title in `ScreenerClassifier`.
3. Add fixtures + a unit test under `NemonicTests/`.

## Status & open items

See `spec.md` for the running checklist (next on deck: tighter OCR ROI to cut sidebar/menu noise, success notifications, multi-image captures, parser unit-awareness vs. schema rewrite).
