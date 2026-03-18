import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var historyService: HistoryService
    @State private var showSettings = false

    var colors: ThemeColors { appState.themeColors }
    var trainingType: TrainingType { appState.selectedTrainingType ?? .easy }

    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerBar

                Divider()
                    .background(colors.border)

                // Scrollable content
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: Theme.spacing24) {
                        ForEach(MealSlot.allCases, id: \.self) { slot in
                            mealSection(for: slot)
                        }
                    }
                    .padding(Theme.spacing24)
                }

                Divider()
                    .background(colors.border)

                // Macro bar
                MacroBarView()
                    .environmentObject(appState)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(spacing: Theme.spacing16) {
            // Back button
            Button(action: { appState.selectedTrainingType = nil }) {
                HStack(spacing: Theme.spacing8) {
                    Image(systemName: "chevron.left")
                        .font(.bodyMedium)
                        .foregroundColor(colors.secondaryText)

                    HStack(spacing: Theme.spacing8) {
                        Text(trainingType.displayName(lang: appState.language))
                            .font(.headingSmall)
                            .foregroundColor(colors.primaryText)

                        Circle()
                            .fill(trainingType.color)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text(formattedDate())
                .font(.bodyRegular)
                .foregroundColor(colors.secondaryText)

            Spacer()

            // Settings button
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape")
                    .font(.bodyMedium)
                    .foregroundColor(colors.secondaryText)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.spacing24)
        .padding(.vertical, Theme.spacing16)
    }

    // MARK: - Meal Section

    private func mealSection(for slot: MealSlot) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing16) {
            HStack {
                Text(L10n.slotName(slot, lang: appState.language))
                    .font(.headingMedium)
                    .foregroundColor(colors.primaryText)

                Spacer()

                Button(action: { regenerateSlot(slot) }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.bodyMedium)
                        .foregroundColor(colors.secondaryText)
                }
                .buttonStyle(.plain)
            }

            if let pair = appState.currentMealPlan[slot] {
                HStack(alignment: .top, spacing: Theme.spacing16) {
                    MealCardView(
                        meal: pair.quick,
                        mode: .quick,
                        weight: appState.userWeight,
                        lang: appState.language,
                        colors: colors
                    )

                    MealCardView(
                        meal: pair.cooked,
                        mode: .cooked,
                        weight: appState.userWeight,
                        lang: appState.language,
                        colors: colors
                    )
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Regenerate

    private func regenerateSlot(_ slot: MealSlot) {
        guard let type = appState.selectedTrainingType else { return }

        let excludedQuick = historyService.recentMealIDs(for: slot, mode: .quick)
        let excludedCooked = historyService.recentMealIDs(for: slot, mode: .cooked)

        if let pair = MealService.shared.generateMealPair(
            lang: appState.language.langCode,
            slot: slot,
            trainingType: type,
            excludedQuickIDs: excludedQuick,
            excludedCookedIDs: excludedCooked
        ) {
            appState.currentMealPlan[slot] = pair
            historyService.recordPair(pair, slot: slot)
        }
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: appState.language == .es ? "es_AR" : "en_US")
        return formatter.string(from: Date())
    }
}
