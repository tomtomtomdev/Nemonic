import SwiftUI

@main
struct NemonicApp: App {

    @State private var coordinator: CaptureCoordinator? = nil
    @State private var loadError: String? = nil

    var body: some Scene {
        MenuBarExtra("Nemonic", systemImage: "viewfinder.circle") {
            if let coordinator {
                MenuBarContentView(coordinator: coordinator)
                    .onAppear {
                        if case .idle = coordinator.status {
                            coordinator.start()
                        }
                    }
            } else if let loadError {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Failed to load screener schemas").font(.headline)
                    Text(loadError).font(.callout).foregroundStyle(.secondary)
                    Button("Quit") { NSApplication.shared.terminate(nil) }
                }
                .padding(12)
                .frame(width: 320)
            } else {
                ProgressView().padding()
                    .task { bootstrap() }
            }
        }
        .menuBarExtraStyle(.window)
    }

    @MainActor
    private func bootstrap() {
        do {
            let registry = try ScreenerRegistry.load()
            coordinator = CaptureCoordinator(registry: registry)
        } catch {
            loadError = error.localizedDescription
        }
    }
}
