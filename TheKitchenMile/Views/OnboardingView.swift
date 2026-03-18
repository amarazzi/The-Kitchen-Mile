import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState

    @State private var weightText: String = ""
    @State private var selectedLanguage: AppLanguage = .en
    @State private var showError: Bool = false

    var colors: ThemeColors { appState.themeColors }

    var body: some View {
        ZStack {
            colors.background.ignoresSafeArea()

            VStack(spacing: Theme.spacing32) {
                Spacer()

                Text(L10n.onboardingTitle(selectedLanguage))
                    .font(.headingLarge)
                    .foregroundColor(colors.primaryText)

                VStack(spacing: Theme.spacing24) {
                    // Language picker
                    VStack(alignment: .leading, spacing: Theme.spacing8) {
                        Text(L10n.languageLabel(selectedLanguage))
                            .font(.bodyMedium)
                            .foregroundColor(colors.secondaryText)

                        Picker("", selection: $selectedLanguage) {
                            ForEach(AppLanguage.allCases, id: \.self) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 280)
                    }

                    // Weight input
                    VStack(alignment: .leading, spacing: Theme.spacing8) {
                        Text(L10n.weightLabel(selectedLanguage))
                            .font(.bodyMedium)
                            .foregroundColor(colors.secondaryText)

                        HStack(spacing: Theme.spacing8) {
                            TextField(L10n.weightPlaceholder(selectedLanguage), text: $weightText)
                                .textFieldStyle(.plain)
                                .font(.headingMedium)
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
                                    showError = false
                                }

                            Text(L10n.weightUnit(selectedLanguage))
                                .font(.bodyMedium)
                                .foregroundColor(colors.secondaryText)
                        }

                        if showError {
                            Text(L10n.weightError(selectedLanguage))
                                .font(.caption)
                                .foregroundColor(Theme.errorColor)
                        }
                    }
                }
                .frame(maxWidth: 320)

                Button(action: completeOnboarding) {
                    Text(L10n.continueButton(selectedLanguage))
                        .font(.bodyMedium)
                        .foregroundColor(colors.background)
                        .padding(.horizontal, Theme.spacing32)
                        .padding(.vertical, Theme.spacing8)
                        .background(colors.primaryText)
                        .cornerRadius(Theme.cornerRadius)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(Theme.spacing40)
        }
    }

    private func completeOnboarding() {
        let trimmed = weightText.trimmingCharacters(in: .whitespaces)

        if trimmed.isEmpty {
            // Use default 70kg
            appState.userWeight = 70.0
        } else if let value = Double(trimmed), value >= 50, value <= 120 {
            appState.userWeight = value
        } else {
            showError = true
            return
        }

        appState.language = selectedLanguage
        appState.hasCompletedOnboarding = true
    }
}
