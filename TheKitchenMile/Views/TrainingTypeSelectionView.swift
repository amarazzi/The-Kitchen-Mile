import SwiftUI

struct TrainingTypeSelectionView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var historyService: HistoryService

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: Theme.spacing32) {
                Spacer()

                VStack(spacing: Theme.spacing12) {
                    // Date eyebrow
                    Text(formattedDate().uppercased())
                        .font(.eyebrow)
                        .foregroundColor(Theme.text3)
                        .tracking(0.06 * 11)

                    // Main question
                    Text(L10n.trainingQuestion(appState.language).uppercased())
                        .font(.displayMedium)
                        .foregroundColor(Theme.text)
                        .multilineTextAlignment(.center)
                        .lineSpacing(-36 * 0.05)
                        .tracking(0.02 * 36)
                }

                // 2×2 grid
                VStack(spacing: Theme.spacing16) {
                    HStack(spacing: Theme.spacing16) {
                        TrainingTypeCard(
                            type: .easy,
                            lang: appState.language,
                            isFeatured: appState.lastUsedTrainingType == .easy
                        ) { selectTrainingType(.easy) }

                        TrainingTypeCard(
                            type: .quality,
                            lang: appState.language,
                            isFeatured: appState.lastUsedTrainingType == .quality
                        ) { selectTrainingType(.quality) }
                    }

                    HStack(spacing: Theme.spacing16) {
                        TrainingTypeCard(
                            type: .longRun,
                            lang: appState.language,
                            isFeatured: appState.lastUsedTrainingType == .longRun
                        ) { selectTrainingType(.longRun) }

                        TrainingTypeCard(
                            type: .rest,
                            lang: appState.language,
                            isFeatured: appState.lastUsedTrainingType == .rest
                        ) { selectTrainingType(.rest) }
                    }
                }
                .frame(maxWidth: 480)

                Spacer()
            }
            .padding(Theme.spacing40)
        }
    }

    private func selectTrainingType(_ type: TrainingType) {
        appState.selectedTrainingType = type
        appState.lastUsedTrainingType = type

        let plan = MealService.shared.generateFullPlan(
            lang: appState.language.langCode,
            trainingType: type,
            historyService: historyService
        )

        appState.currentMealPlan = plan

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

// MARK: - Training Type Card

struct TrainingTypeCard: View {
    let type: TrainingType
    let lang: AppLanguage
    let isFeatured: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    // Eyebrow label
                    if isFeatured {
                        Text(L10n.lastUsedLabel(lang).uppercased())
                            .font(.eyebrowSmall)
                            .foregroundColor(Theme.accent)
                            .tracking(0.12 * 10)
                    } else {
                        Text(type.eyebrowLabel(lang: lang).uppercased())
                            .font(.eyebrowSmall)
                            .foregroundColor(Theme.text3)
                            .tracking(0.12 * 10)
                    }

                    // Name
                    Text(type.displayName(lang: lang).uppercased())
                        .font(.displaySmall)
                        .foregroundColor(Theme.text)
                        .tracking(0.02 * 22)

                    // Subtitle
                    Text(type.subtitle(lang: lang))
                        .font(.bodySmall)
                        .foregroundColor(Theme.text2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Lime dot for featured
                if isFeatured {
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(Theme.cardPadding)
            .background(isFeatured ? Theme.accentDim : Theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(
                        isFeatured ? Theme.accentBorder : (isHovered ? Theme.text3 : Theme.border),
                        lineWidth: 1
                    )
            )
            .cornerRadius(Theme.cornerRadius)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
}
