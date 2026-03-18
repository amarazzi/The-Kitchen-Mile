import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var weightText: String = ""
    @State private var showError: Bool = false

    var colors: ThemeColors { appState.themeColors }

    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: Theme.spacing24) {
                HStack {
                    Text(L10n.settingsTitle(appState.language))
                        .font(.headingMedium)
                        .foregroundColor(colors.primaryText)

                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.bodyMedium)
                            .foregroundColor(colors.secondaryText)
                    }
                    .buttonStyle(.plain)
                }

                // Weight
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    Text(L10n.weightLabel(appState.language))
                        .font(.bodyMedium)
                        .foregroundColor(colors.secondaryText)

                    HStack(spacing: Theme.spacing8) {
                        TextField(
                            L10n.weightPlaceholder(appState.language),
                            text: $weightText
                        )
                        .textFieldStyle(.plain)
                        .font(.headingSmall)
                        .foregroundColor(colors.primaryText)
                        .frame(width: 80)
                        .padding(.horizontal, Theme.spacing16)
                        .padding(.vertical, Theme.spacing8)
                        .background(colors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .stroke(showError ? Theme.errorColor : colors.border, lineWidth: 1)
                        )
                        .cornerRadius(Theme.cornerRadius)
                        .onChange(of: weightText) { _ in
                            validateAndApplyWeight()
                        }

                        Text(L10n.weightUnit(appState.language))
                            .font(.bodyMedium)
                            .foregroundColor(colors.secondaryText)
                    }

                    if showError {
                        Text(L10n.weightError(appState.language))
                            .font(.caption)
                            .foregroundColor(Theme.errorColor)
                    }
                }

                // Language
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    Text(L10n.languageLabel(appState.language))
                        .font(.bodyMedium)
                        .foregroundColor(colors.secondaryText)

                    Picker("", selection: $appState.language) {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 240)
                }

                // Appearance
                VStack(alignment: .leading, spacing: Theme.spacing8) {
                    Text(L10n.appearanceLabel(appState.language))
                        .font(.bodyMedium)
                        .foregroundColor(colors.secondaryText)

                    Picker("", selection: $appState.appearance) {
                        Text(L10n.darkLabel(appState.language)).tag(AppearanceMode.dark)
                        Text(L10n.lightLabel(appState.language)).tag(AppearanceMode.light)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 240)
                }

                Spacer()
            }
            .padding(Theme.spacing24)
        }
        .frame(width: 380, height: 340)
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
