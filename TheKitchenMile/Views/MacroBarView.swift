import SwiftUI

struct MacroBarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        let actual = appState.actualMacros()
        let targets = appState.dailyTargets()

        HStack(spacing: Theme.spacing24) {
            if let targets = targets {
                macroColumn(
                    label: L10n.carbsLabel(appState.language),
                    actual: actual.carbs,
                    target: targets.carbs
                )

                macroColumn(
                    label: L10n.proteinLabel(appState.language),
                    actual: actual.protein,
                    target: targets.protein
                )

                macroColumn(
                    label: L10n.fatLabel(appState.language),
                    actual: actual.fat,
                    target: targets.fat
                )

                Spacer()

                // Total kcal
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formatNumber(actual.kcal))
                        .font(.numberMedium)
                        .foregroundColor(Theme.text)

                    Text(L10n.totalKcalLabel(appState.language).uppercased())
                        .font(.ingredientText)
                        .foregroundColor(Theme.text3)
                }
            }
        }
        .padding(.horizontal, Theme.spacing24)
        .padding(.vertical, Theme.spacing16)
        .background(Theme.surface)
        .overlay(
            Rectangle()
                .fill(Theme.border)
                .frame(height: 1),
            alignment: .top
        )
    }

    private func macroColumn(label: String, actual: Int, target: Int) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing4) {
            // Label
            Text(label.uppercased())
                .font(.eyebrowMicro)
                .foregroundColor(Theme.text3)
                .tracking(0.12 * 9)

            // Value + target
            HStack(alignment: .firstTextBaseline, spacing: Theme.spacing4) {
                Text("\(actual)g")
                    .font(.headingSmall)
                    .foregroundColor(Theme.text)

                Text("/ \(target)g")
                    .font(.ingredientText)
                    .foregroundColor(Theme.text3)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(Theme.surface3)
                        .frame(height: Theme.progressBarHeight)

                    // Fill
                    let progress = target > 0 ? min(Double(actual) / Double(target), 1.5) : 0
                    let isOver = actual > target
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(isOver ? Theme.overTargetColor : Theme.accent)
                        .frame(width: geo.size.width * min(progress, 1.0), height: Theme.progressBarHeight)
                }
            }
            .frame(height: Theme.progressBarHeight)
            .frame(width: 100)
        }
    }

    private func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}
