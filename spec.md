mark as done:
- [x] detect screenshot image in Desktop/ matching sample image in this folder
- [x] read with ocr apple vision to extract textual data
- [x] save to json file with structure matching sample json with corresponding name in this folder
- [x] delete detected image for cleanup
- [x] menu-bar app (MenuBarExtra, LSUIElement=YES, sandbox off)
- [x] DispatchSource watcher on ~/Desktop for `Screenshot *.png`
- [x] Vision OCR via `RecognizeDocumentsRequest` + `RecognizeTextRequest` (parallel)
- [x] Screener classification by title aliases
- [x] Column-order schema loaded from bundled `sample-*.json` files
- [x] JSON writer preserves key order; numbers stay numeric, formatted values stay string
- [x] Output written to `~/Desktop/<screener-id>.json`
- [x] Source PNG moved to Trash on success
- [x] Unit tests (26 passing): parser, JSON writer, registry, classifier, row mapper
- [x] RowMapper noise filters: reject rows whose first cell isn't a 4-letter IDX ticker, or that have fewer than `schema.keys.count - 2` cells (kills sidebar/menu/footer OCR noise)

state of work (2026-05-16):
- build green; `xcodebuild test` passes 26 unit + 4 UI tests
- pipeline wired end-to-end: `NemonicApp` → `CaptureCoordinator` → `ScreenshotWatcher` → `VisionOCRService` → `ScreenerClassifier` → `RowMapper` → `JSONWriter` → `FileSink` (writes `~/Desktop/<id>.json`, trashes source PNG)
- 8 bundled schemas under `Nemonic/Resources/sample-*.json`; matching aliases in classifier
- menu-bar UI shows live event log + start/stop; auto-starts watcher on first menu open
- skipped on no-match / no-table / no-rows: file is NOT trashed (safe-by-default)

parser contract (current behavior, per `NumericValueParser` + tests):
- empty / `-` / `—` → `""`
- pure digits with optional commas → `.int` (e.g. `8,973,753,750` → `8973753750`)
- any cell containing `.`, `%`, `(`, `)`, or a letter → `.string`, preserved verbatim after whitespace strip
  - so `26.79 B` → `"26.79B"`, `(424.38 B)` → `"(424.38B)"`, `60.25%` → `"60.25%"`, `0.072` → `"0.072"`
- first cell of every row is forced to `.string` (ticker code)
- schema does NOT declare per-column type; output type is decided per-cell by the parser
- known loss: sign encoded only by color (red %) is not recovered — if a `%` column can be negative, OCR must surface a textual `-`

not yet done:
- [ ] end-to-end smoke test against real screeners (8 untracked `Screenshot *.png` in repo root — none on `~/Desktop` yet, so watcher hasn't seen them)
- [ ] crop OCR region of interest to the data-table area only — full-screen captures currently pull in macOS menu bar, Stockbit sidebar (screener names), and Dock/ticker bar; the RowMapper filters discard the noise rows but a tighter ROI would also help the classifier and the spatial-table fallback
- [ ] handle multi-image screener captures (current pipeline assumes one PNG per screener)
- [ ] notification on success / no-match (currently only the menu-bar log surfaces results)
- [ ] retry / requeue UI for PNGs the classifier skipped
- [ ] reconcile parser contract with integer-target sample JSONs — `sample-confluence-universe-filter.json` stores `value-ma-20: 8973753750`, `1-month-net-foreign-flow: 26790000000`, `bandar-value-ma-10: -424380000000`, but the OCR'd cells (`8,973,753,750.00`, `26.79 B`, `(424.38 B)`) currently round-trip as strings. Either (a) extend the parser with unit-aware (`B`/`M`/`K`/`T` ×1e9/1e6/1e3/1e12), parens-as-negative, and `.00`-trim conversion, gated by a schema-declared per-column type, or (b) rewrite the affected sample JSONs to use the string form the parser actually emits. Decide before the next sample is added.
