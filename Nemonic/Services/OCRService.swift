import Foundation

nonisolated struct OCRTable: Sendable, Equatable {
    /// Rows in top-to-bottom order; each row is its cells left-to-right.
    let rows: [[String]]
    /// Normalized bounding-box area (0…1) — used to pick the biggest table on the page.
    let area: Double
}

nonisolated struct OCRResult: Sendable, Equatable {
    /// Concatenated full-page text used by the classifier to identify which screener it is.
    let pageText: String
    /// Best-effort structured tables found on the page (empty if Vision didn't detect any).
    let tables: [OCRTable]
}

protocol OCRService: Sendable {
    func recognize(imageAt url: URL) async throws -> OCRResult
}
