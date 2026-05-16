import Foundation

nonisolated struct ScreenerClassifier: Sendable {
    let registry: ScreenerRegistry

    /// Find the screener whose `titleAliases` best matches the OCR'd page text.
    /// Returns nil if no alias appears in the input.
    func classify(pageText: String) -> ScreenerSchema? {
        let haystack = pageText.lowercased()
        var best: (schema: ScreenerSchema, score: Int)?
        for schema in registry.schemas {
            var score = 0
            for alias in schema.titleAliases {
                if haystack.contains(alias.lowercased()) {
                    score += alias.count // prefer longer alias matches
                }
            }
            if score > 0, score > (best?.score ?? 0) {
                best = (schema, score)
            }
        }
        return best?.schema
    }
}
