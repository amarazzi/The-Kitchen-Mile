import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var historyService: HistoryService
    @State private var showSettings = false

    var trainingType: TrainingType { appState.selectedTrainingType ?? .easy }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: Theme.spacing24) {
                        ForEach(MealSlot.allCases, id: \.self) { slot in
                            mealSection(for: slot)
                        }
                    }
                    .padding(Theme.spacing24)
                }

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
                Text(L10n.backLabel(appState.language).uppercased())
                    .font(.bodySmallMedium)
                    .foregroundColor(Theme.text3)
                    .tracking(0.06 * 12)
            }
            .buttonStyle(.plain)

            // Training type title + badge
            HStack(spacing: Theme.spacing8) {
                Text(trainingType.displayName(lang: appState.language).uppercased())
                    .font(.headingLarge)
                    .foregroundColor(Theme.text)
                    .tracking(0.02 * 20)

                // Active badge
                Text(L10n.activeLabel(appState.language).uppercased())
                    .font(.eyebrowSmall)
                    .foregroundColor(Theme.accent)
                    .tracking(0.10 * 10)
                    .padding(.horizontal, Theme.spacing8)
                    .padding(.vertical, 3)
                    .background(Theme.accentDim)
                    .cornerRadius(Theme.cornerRadiusBadge)
            }

            Spacer()

            // Date
            Text(formattedDate().uppercased())
                .font(.bodySmallMedium)
                .foregroundColor(Theme.text3)
                .tracking(0.06 * 12)

            // Settings button
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.text3)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.spacing24)
        .padding(.vertical, Theme.spacing16)
        .background(Theme.bg)
        .overlay(
            Rectangle()
                .fill(Theme.border)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    // MARK: - Meal Section

    private func mealSection(for slot: MealSlot) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing12) {
            HStack {
                Text(L10n.slotName(slot, lang: appState.language).uppercased())
                    .font(.headingMedium)
                    .foregroundColor(Theme.text)
                    .tracking(0.03 * 18)

                Spacer()

                Button(action: { regenerateSlot(slot) }) {
                    Text(L10n.shuffleLabel(appState.language).uppercased())
                        .font(.ingredientMedium)
                        .foregroundColor(Theme.text3)
                        .tracking(0.06 * 11)
                }
                .buttonStyle(.plain)
            }

            if let pair = appState.currentMealPlan[slot] {
                HStack(alignment: .top, spacing: Theme.spacing16) {
                    MealCardView(
                        meal: pair.quick,
                        mode: .quick,
                        weight: appState.userWeight,
                        lang: appState.language
                    )

                    MealCardView(
                        meal: pair.cooked,
                        mode: .cooked,
                        weight: appState.userWeight,
                        lang: appState.language
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
