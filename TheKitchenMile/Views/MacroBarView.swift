import SwiftUI

struct MacroBarView: View {
    @EnvironmentObject var appState: AppState

    var colors: ThemeColors { appState.themeColors }

    var body: some View {
        let actual = appState.actualMacros()
        let targets = appState.dailyTargets()

        HStack(spacing: Theme.spacing24) {
            if let targets = targets {
                macroItem(
                    label: L10n.carbsLabel(appState.language),
                    actual: actual.carbs,
                    target: targets.carbs,
                    unit: "g"
                )

                macroItem(
                    label: L10n.proteinLabel(appState.language),
                    actual: actual.protein,
                    target: targets.protein,
                    unit: "g"
                )

                macroItem(
                    label: L10n.fatLabel(appState.language),
                    actual: actual.fat,
                    target: targets.fat,
                    unit: "g"
                )

                Spacer()

                Text("~\(formatNumber(actual.kcal)) kcal")
                    .font(.bodyMedium)
                    .foregroundColor(colors.primaryText)
            }
        }
        .padding(.horizontal, Theme.spacing24)
        .padding(.vertical, Theme.spacing16)
    }

    private func macroItem(label: String, actual: Int, target: Int, unit: String) -> some View {
        HStack(spacing: Theme.spacing4) {
            Text(label)
                .font(.captionMedium)
                .foregroundColor(colors.secondaryText)

            Text("\(actual)\(unit)")
                .font(.bodyMedium)
                .foregroundColor(colors.primaryText)

            Text("/ \(target)\(unit) \(L10n.targetLabel(appState.language))")
                .font(.caption)
                .foregroundColor(colors.tertiaryText)
        }
    }

    private func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}
