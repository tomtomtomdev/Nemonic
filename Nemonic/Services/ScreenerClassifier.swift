import Foundation

nonisolated struct ScreenerClassifier: Sendable {
    let registry: ScreenerRegistry

    /// Find the screener whose `titleAliases` best matches the OCR'd page text.
    /// Returns nil if no alias appears in the input.
    ///
    /// Stockbit captures the whole sidebar of saved screener names, so most schemas have at
    /// least one alias hit. The selected screener is the only one whose title appears *twice*
    /// (sidebar entry + panel header `... | Edit | N Symbols`). Score = `alias.length × occurrences`
    /// so repeated mentions outweigh sidebar noise.
    func classify(pageText: String) -> ScreenerSchema? {
        let haystack = pageText.lowercased()
        var best: (schema: ScreenerSchema, score: Int)?
        for schema in registry.schemas {
            var score = 0
            for alias in schema.titleAliases {
                let occurrences = haystack.components(separatedBy: alias.lowercased()).count - 1
                score += alias.count * occurrences
            }
            if score > 0, score > (best?.score ?? 0) {
                best = (schema, score)
            }
        }
        return best?.schema
    }
}
