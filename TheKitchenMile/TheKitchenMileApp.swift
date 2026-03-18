import SwiftUI

@main
struct TheKitchenMileApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var historyService = HistoryService()

    init() {
        FontLoader.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(historyService)
                .preferredColorScheme(appState.appearance == .dark ? .dark : .light)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(
            width: Theme.windowDefaultWidth,
            height: Theme.windowDefaultHeight
        )
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var historyService: HistoryService

    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else if appState.selectedTrainingType == nil {
                TrainingTypeSelectionView(historyService: historyService)
            } else {
                MealPlanView(historyService: historyService)
            }
        }
        .frame(
            minWidth: Theme.windowMinWidth,
            minHeight: Theme.windowMinHeight
        )
        .background(appState.colors.bg)
    }
}
