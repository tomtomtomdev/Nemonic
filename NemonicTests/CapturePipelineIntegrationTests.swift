import Testing
import Foundation
@testable import Nemonic

/// End-to-end OCR pipeline tests against real Stockbit screenshots.
/// Loads the actual PNG, runs Vision OCR, classifies, maps rows, and asserts the
/// produced JSON corresponds to the expected screener schema.
struct CapturePipelineIntegrationTests {

    @Test func quietBandarPanelScreenshotProducesQuietBandarJSON() async throws {
        let url = try fixture(named: "quiet-bandar-panel", ext: "png")
        let registry = try ScreenerRegistry.load(bundle: .main)

        let ocr = VisionOCRService()
        let result = try await ocr.recognize(imageAt: url)

        if Self.printDebug { print("--- pageText ---\n\(result.pageText)\n--- end ---") }

        // 1. Classifier picks Quiet Bandar Accumulation despite icon-OCR noise and column headers.
        let classifier = ScreenerClassifier(registry: registry)
        let schema = try #require(classifier.classify(pageText: result.pageText))
        #expect(schema.id == "quiet-bandar-accumulation",
                "expected quiet-bandar-accumulation; got \(schema.id). pageText=\(result.pageText)")

        // 2. RowMapper recovers the BANK ticker from "A BANK" icon-prefixed cells and emits a
        //    single canonical row per stock.
        let table = try #require(result.tables.first)
        let mapped = RowMapper().map(tableRows: Array(table.rows.dropFirst()), using: schema)
        let tickers = mapped.map { $0.pairs.first?.value }
        #expect(tickers.contains(.string("BANK")), "expected BANK; got \(tickers)")

        // 3. FileSink writes <screener-id>.json deterministically — running twice overwrites
        //    the existing file rather than producing duplicates.
        let tmp = try makeTempDir()
        let sink = FileSink()
        let first = try sink.write(rows: mapped, for: schema, outputDirectory: tmp)
        let stamp1 = try FileManager.default.attributesOfItem(atPath: first.path)[.modificationDate] as? Date
        try await Task.sleep(nanoseconds: 1_100_000_000) // ensure mtime differs
        let second = try sink.write(rows: mapped, for: schema, outputDirectory: tmp)
        let stamp2 = try FileManager.default.attributesOfItem(atPath: second.path)[.modificationDate] as? Date

        #expect(first == second, "FileSink must reuse the same path per screener id")
        #expect(first.lastPathComponent == "quiet-bandar-accumulation.json")
        #expect(stamp1 != stamp2, "second write should overwrite, updating mtime")

        let allJSON = try FileManager.default.contentsOfDirectory(atPath: tmp.path)
            .filter { $0.hasSuffix(".json") }
        #expect(allJSON == ["quiet-bandar-accumulation.json"],
                "exactly one canonical JSON per screener; got \(allJSON)")
    }

    @Test func bbSqueezePanelScreenshotProducesBBSqueezeJSON() async throws {
        let url = try fixture(named: "bb-squeeze-breakout-panel", ext: "png")
        let registry = try ScreenerRegistry.load(bundle: .main)

        let ocr = VisionOCRService()
        let result = try await ocr.recognize(imageAt: url)

        if Self.printDebug { print("--- pageText ---\n\(result.pageText)\n--- end ---") }

        // 1. Classifier picks Bulkowski BB Squeeze Breakout (title in panel header).
        let classifier = ScreenerClassifier(registry: registry)
        let schema = try #require(classifier.classify(pageText: result.pageText))
        #expect(schema.id == "bb-squeeze-breakout",
                "expected bb-squeeze-breakout; got \(schema.id). pageText=\(result.pageText)")

        // 2. RowMapper recovers all four tickers from icon-prefixed cells.
        let table = try #require(result.tables.first)
        let mapped = RowMapper().map(tableRows: Array(table.rows.dropFirst()), using: schema)
        let tickers = Set(mapped.compactMap { row -> String? in
            if case .string(let s) = row.pairs.first?.value { return s }
            return nil
        })
        #expect(tickers == ["KJEN", "KOPI", "NEST", "BSWD"],
                "expected KJEN/KOPI/NEST/BSWD; got \(tickers)")

        // 3. Mapped rows align with the 7-column schema so each non-empty value lands on the
        //    correct key — verified spot-check that BSWD's 1-day-volume-change reads "100.00%"
        //    (catches the prior bug where %-strings were mis-mapped onto bb-lower-20).
        let bswd = try #require(mapped.first { row in
            if case .string("BSWD") = row.pairs.first?.value { return true }
            return false
        })
        let bswdChange = bswd.pairs.first { $0.key == "1-day-volume-change" }?.value
        #expect(bswdChange == .string("100.00%"),
                "BSWD 1-day-volume-change misaligned; got \(String(describing: bswdChange))")

        // 4. FileSink writes <screener-id>.json deterministically.
        let tmp = try makeTempDir()
        let sink = FileSink()
        let written = try sink.write(rows: mapped, for: schema, outputDirectory: tmp)
        #expect(written.lastPathComponent == "bb-squeeze-breakout.json")
    }

    private func makeTempDir() throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("nemonic-itest-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    // MARK: - Helpers

    private static let printDebug = ProcessInfo.processInfo.environment["NEMONIC_TEST_DEBUG"] == "1"

    /// Fixtures live at `<repo>/TestFixtures/` (a sibling of NemonicTests/, deliberately *outside*
    /// the synced root group). That keeps macOS-extended-attribute-bearing PNGs out of the test
    /// xctest bundle — otherwise `com.apple.provenance` makes codesigning the test bundle fail.
    private func fixture(named name: String, ext: String) throws -> URL {
        let here = URL(fileURLWithPath: #filePath)               // .../NemonicTests/CapturePipelineIntegrationTests.swift
        let repoRoot = here.deletingLastPathComponent().deletingLastPathComponent()
        let candidate = repoRoot.appendingPathComponent("TestFixtures/\(name).\(ext)")
        guard FileManager.default.fileExists(atPath: candidate.path) else {
            throw FixtureMissing.notFound(candidate.path)
        }
        return candidate
    }

    enum FixtureMissing: Error { case notFound(String) }
}
