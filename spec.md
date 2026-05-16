feature plan:
detect screenshot image in Desktop/ matching sample image in this folder
read with ocr apple vision to extract textual data
save to json file with structure matching sample json with corresponding name in this folder
delete detected image for cleanup

mark as done:
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

not yet done:
- [ ] end-to-end smoke test against real screeners (8 untracked `Screenshot *.png` in repo root — none on `~/Desktop` yet, so watcher hasn't seen them)
- [ ] crop OCR region of interest to the data-table area only — full-screen captures currently pull in macOS menu bar, Stockbit sidebar (screener names), and Dock/ticker bar; the RowMapper filters discard the noise rows but a tighter ROI would also help the classifier and the spatial-table fallback
- [ ] handle multi-image screener captures (current pipeline assumes one PNG per screener)
- [ ] notification on success / no-match (currently only the menu-bar log surfaces results)
- [ ] retry / requeue UI for PNGs the classifier skipped
