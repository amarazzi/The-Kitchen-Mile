import SwiftUI

struct TrainingTypeSelectionView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var historyService: HistoryService

    var colors: ThemeColors { appState.themeColors }

    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()

            VStack(spacing: Theme.spacing32) {
                Spacer()

                Text(formattedDate())
                    .font(.bodyMedium)
                    .foregroundColor(colors.secondaryText)

                Text(L10n.trainingQuestion(appState.language))
                    .font(.headingLarge)
                    .foregroundColor(colors.primaryText)

                HStack(spacing: Theme.spacing16) {
                    ForEach(TrainingType.allCases, id: \.self) { type in
                        TrainingTypeButton(
                            type: type,
                            lang: appState.language,
                            colors: colors
                        ) {
                            selectTrainingType(type)
                        }
                    }
                }

                Spacer()
            }
            .padding(Theme.spacing40)
        }
    }

    private func selectTrainingType(_ type: TrainingType) {
        appState.selectedTrainingType = type

        let plan = MealService.shared.generateFullPlan(
            lang: appState.language.langCode,
            trainingType: type,
            historyService: historyService
        )

        appState.currentMealPlan = plan

        // Record all meals in history
        for (slot, pair) in plan {
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

// MARK: - Training Type Button

struct TrainingTypeButton: View {
    let type: TrainingType
    let lang: AppLanguage
    let colors: ThemeColors
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.spacing8) {
                Text(type.shortName(lang: lang))
                    .font(.bodyMedium)
                    .foregroundColor(isHovered ? colors.background : colors.primaryText)
            }
            .padding(.horizontal, Theme.spacing24)
            .padding(.vertical, Theme.spacing16)
            .background(isHovered ? type.color : colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(isHovered ? type.color : colors.border, lineWidth: 1)
            )
            .cornerRadius(Theme.cornerRadius)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}
