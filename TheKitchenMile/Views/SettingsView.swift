import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var weightText: String = ""
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: Theme.spacing24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: Theme.spacing4) {
                        Text(L10n.settingsEyebrow(appState.language).uppercased())
                            .font(.eyebrow)
                            .foregroundColor(Theme.accent)
                            .tracking(0.06 * 11)

                        Text(L10n.settingsTitle(appState.language).uppercased())
                            .font(.displayMedium)
                            .foregroundColor(Theme.text)
                            .tracking(0.02 * 36)
                    }

                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.text3)
                    }
                    .buttonStyle(.plain)
                }

                // Divider
                Rectangle()
                    .fill(Theme.border)
                    .frame(height: 1)

                // Weight group
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    Text(L10n.weightLabel(appState.language).uppercased())
                        .font(.eyebrowMicro)
                        .foregroundColor(Theme.text3)
                        .tracking(0.12 * 9)

                    HStack(alignment: .firstTextBaseline, spacing: Theme.spacing8) {
                        TextField(
                            L10n.weightPlaceholder(appState.language),
                            text: $weightText
                        )
                        .textFieldStyle(.plain)
                        .font(.numberLarge)
                        .foregroundColor(Theme.accent)
                        .frame(width: 120)
                        .onChange(of: weightText) { _ in
                            validateAndApplyWeight()
                        }

                        Text(L10n.weightUnit(appState.language))
                            .font(.bodyMedium)
                            .foregroundColor(Theme.text2)
                    }
                    .padding(.horizontal, Theme.spacing24)
                    .padding(.vertical, Theme.spacing16)
                    .background(Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(showError ? Theme.errorColor : Theme.border, lineWidth: 1)
                    )
                    .cornerRadius(Theme.cornerRadius)

                    if showError {
                        Text(L10n.weightError(appState.language))
                            .font(.ingredientText)
                            .foregroundColor(Theme.errorColor)
                    }
                }

                // Divider
                Rectangle()
                    .fill(Theme.border)
                    .frame(height: 1)

                // Language group
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    Text(L10n.languageLabel(appState.language).uppercased())
                        .font(.eyebrowMicro)
                        .foregroundColor(Theme.text3)
                        .tracking(0.12 * 9)

                    SegmentedControl(
                        options: AppLanguage.allCases,
                        selection: $appState.language,
                        label: { $0.displayName }
                    )
                    .frame(maxWidth: 280)
                }

                // Divider
                Rectangle()
                    .fill(Theme.border)
                    .frame(height: 1)

                // Appearance group
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    Text(L10n.appearanceLabel(appState.language).uppercased())
                        .font(.eyebrowMicro)
                        .foregroundColor(Theme.text3)
                        .tracking(0.12 * 9)

                    SegmentedControl(
                        options: AppearanceMode.allCases,
                        selection: $appState.appearance,
                        label: {
                            $0 == .dark
                                ? L10n.darkLabel(appState.language)
                                : L10n.lightLabel(appState.language)
                        }
                    )
                    .frame(maxWidth: 280)
                }

                Spacer()
            }
            .padding(Theme.spacing24)
        }
        .frame(width: 400, height: 480)
        .onAppear {
            weightText = "\(Int(appState.userWeight))"
        }
    }

    private func validateAndApplyWeight() {
        let trimmed = weightText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            showError = false
            return
        }

        if let value = Double(trimmed), value >= 50, value <= 120 {
            showError = false
            appState.userWeight = value
        } else if let _ = Double(trimmed) {
            showError = true
        }
    }
}
