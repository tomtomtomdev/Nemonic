# Nemonic — Project Instructions

macOS / SwiftUI project. Project-level skills live in `.claude/skills/`.

## Skill Routing

When the user's request matches a trigger below, invoke the corresponding skill **before** responding.
Multiple skills may apply — invoke each that fits.

| Trigger keywords / intents | Skill |
|---|---|
| Mac app, macOS, AppKit, SwiftUI window/menu bar/scene, SwiftData, Xcode setup, sandboxing, notarization, code signing, entitlements, `@Observable`, `MenuBarExtra`, `NSHostingView` | `macos-development` |
| SwiftUI architecture, ViewModel size, MVVM vs UDF, TCA, reducer, feature store, "scale my SwiftUI app", VIP for SwiftUI, navigation patterns, DI in SwiftUI | `swiftui-architecture` |
| Clean Architecture, SOLID, dependency rule, use cases, entities, ports & adapters, hexagonal, onion, "where does this logic go", "decouple X from Y" | `clean-architecture` |
| "Is this code good", code review, readability, naming, function/class size, code smells, Boy Scout rule, Uncle Bob, F.I.R.S.T. tests | `clean-code` |
| Refactor, simplify, Extract Function/Variable/Class, Inline X, Move Method, Replace Conditional with Polymorphism, Hide Delegate, "two hats", behavior-preserving change, Fowler | `refactoring-fowler` |
| TDD, test-first, red-green-refactor, XCTest, "how do I test this", mock/stub/fake, Kent Beck, characterization vs unit test, starter test, triangulation | `tdd-kent-beck` |
| Untested code, "I can't test this", break dependencies, seam, sprout/wrap method, characterization tests, get into a test harness, Michael Feathers | `legacy-code` |
| Apple Vision framework, `VNRequest`/`ImageRequestHandler`, face/text/barcode/body-pose/hand-pose detection, OCR, `RecognizeTextRequest`, `RecognizeDocumentsRequest`, `DetectBarcodesRequest`, saliency, person segmentation, CoreML via Vision, AVFoundation + Vision live camera pipeline, normalized coordinates/bounding box flip, migrating `VN`-prefixed API to iOS 18 Swift API | `apple-vision` |

## Combination Rules

- **New SwiftUI feature** → `swiftui-architecture` + `tdd-kent-beck`
- **Refactoring tangled untested code** → `legacy-code` first (get tests in place) → `refactoring-fowler`
- **Designing module boundaries** → `clean-architecture` + `swiftui-architecture`
- **Code review** → `clean-code` (always); add `swiftui-architecture` or `clean-architecture` if structural
- **macOS-specific question** → `macos-development` (always); layer in others as needed

## Defaults

- Architecture: UDF + lightweight clean boundaries (see `swiftui-architecture`)
- State: `@Observable` over `ObservableObject` for new code
- Concurrency: Swift Concurrency (async/await + actors) over Combine for new code
- Persistence: SwiftData (macOS 14+)
- **Tests: ALWAYS use TDD when adding new features.** Write a failing test first, then make it pass, then refactor. Characterization tests before changing untested code. No new behavior ships without a test that would have failed before the change.
