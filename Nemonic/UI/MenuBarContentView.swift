import SwiftUI

struct MenuBarContentView: View {
    @Bindable var coordinator: CaptureCoordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                statusDot
                Text(statusText).font(.headline)
                Spacer()
                Button(action: toggle) {
                    Text(isRunning ? "Stop" : "Start")
                }
                .buttonStyle(.borderedProminent)
            }

            Divider()

            SignalsSection(watchlist: coordinator.watchlist)

            Divider()

            if coordinator.events.isEmpty {
                Text("No events yet. Take a screenshot of a screener.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(coordinator.events) { event in
                            EventRow(event: event)
                        }
                    }
                }
                .frame(maxHeight: 280)
            }

            Divider()

            HStack {
                Button("Quit Nemonic") {
                    NSApplication.shared.terminate(nil)
                }
                Spacer()
            }
        }
        .padding(12)
        .frame(width: 380)
    }

    private var isRunning: Bool {
        if case .watching = coordinator.status { return true }
        return false
    }

    private var statusText: String {
        switch coordinator.status {
        case .idle: return "Idle"
        case .watching: return "Watching Desktop"
        case .stopped: return "Stopped"
        case .failed(let msg): return "Error: \(msg)"
        }
    }

    private var statusDot: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 8, height: 8)
    }

    private var statusColor: Color {
        switch coordinator.status {
        case .idle: return .gray
        case .watching: return .green
        case .stopped: return .orange
        case .failed: return .red
        }
    }

    private func toggle() {
        if isRunning { coordinator.stop() }
        else { coordinator.start() }
    }
}

private struct SignalsSection: View {
    @Bindable var watchlist: Watchlist

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Signals").font(.headline)
                Spacer()
                if !watchlist.hasConfluence {
                    Text("awaiting #1 confluence")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(watchlist.signals.count) hit\(watchlist.signals.count == 1 ? "" : "s")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            if watchlist.signals.isEmpty {
                Text(watchlist.hasConfluence
                     ? "No survivors yet. Capture #2-#8 screeners."
                     : "Capture the Confluence Universe Filter first.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 2)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(watchlist.signals) { signal in
                            SignalRow(signal: signal)
                        }
                    }
                }
                .frame(maxHeight: 180)
            }
        }
    }
}

private struct SignalRow: View {
    let signal: ScreenerSignal

    var body: some View {
        HStack(spacing: 6) {
            Text(signal.ticker)
                .font(.system(.callout, design: .monospaced).bold())
                .frame(width: 52, alignment: .leading)
            VStack(alignment: .leading, spacing: 0) {
                Text(shortScreener)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Text("buy \(idr(signal.entry))")
                    Text("•").foregroundStyle(.tertiary)
                    Text("stop \(idr(signal.stop))").foregroundStyle(.secondary)
                }
                .font(.caption2)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                Text(String(format: "%.1f%%", signal.plan.allocationPct * 100))
                    .font(.callout.monospacedDigit().bold())
                Text("\(signal.plan.shares.formatted()) sh")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private var shortScreener: String {
        switch signal.screenerId {
        case "classical-trend-follower": return "Murphy trend"
        case "quiet-bandar-accumulation": return "Bandarmology"
        case "bb-squeeze-breakout": return "BB squeeze"
        case "with-trend-pullback": return "Grimes pullback"
        case "livermore-pivotal-point": return "Livermore"
        case "coulling-stopping-volume": return "VPA stopping"
        case "wyckoff-phase-c-spring": return "Wyckoff spring"
        default: return signal.screenerId
        }
    }

    private func idr(_ v: Int) -> String {
        // IDR uses dot thousands separators in Indonesian convention.
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = "."
        return f.string(from: NSNumber(value: v)) ?? "\(v)"
    }
}

private struct EventRow: View {
    let event: CaptureCoordinator.Event

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.caption)
                .frame(width: 14, alignment: .center)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 0) {
                Text(event.message).font(.callout)
                Text(event.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private var icon: String {
        switch event.kind {
        case .info: return "info.circle"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        }
    }

    private var color: Color {
        switch event.kind {
        case .info: return .secondary
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}
