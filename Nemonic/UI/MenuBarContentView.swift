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
