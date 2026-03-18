import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState

    @State private var weightText: String = ""
    @State private var selectedLanguage: AppLanguage = .en
    @State private var showError: Bool = false

    private var c: ThemeColorSet { appState.colors }

    var body: some View {
        ZStack {
            c.bg.ignoresSafeArea()

            VStack(spacing: Theme.spacing32) {
                Spacer()

                VStack(spacing: Theme.spacing12) {
                    // Eyebrow
                    Text(L10n.onboardingEyebrow(selectedLanguage).uppercased())
                        .font(.eyebrow)
                        .foregroundColor(Theme.accent)
                        .tracking(0.06 * 11)

                    // Main heading
                    Text(L10n.onboardingTitle(selectedLanguage).uppercased())
                        .font(.displayLarge)
                        .foregroundColor(c.text)
                        .multilineTextAlignment(.center)
                        .tracking(0.02 * 44)
                }

                VStack(spacing: Theme.spacing24) {
                    // Weight input block
                    VStack(alignment: .leading, spacing: Theme.spacing8) {
                        Text(L10n.weightLabel(selectedLanguage).uppercased())
                            .font(.eyebrowMicro)
                            .foregroundColor(c.text3)
                            .tracking(0.12 * 9)

                        HStack(alignment: .firstTextBaseline, spacing: Theme.spacing8) {
                            TextField(L10n.weightPlaceholder(selectedLanguage), text: $weightText)
                                .textFieldStyle(.plain)
                                .font(.numberLarge)
                                .foregroundColor(Theme.accent)
                                .frame(width: 120)
                                .onChange(of: weightText) { _ in
                                    showError = false
                                }

                            Text(L10n.weightUnit(selectedLanguage))
                                .font(.bodyMedium)
                                .foregroundColor(c.text2)
                        }
                        .padding(.horizontal, Theme.spacing24)
                        .padding(.vertical, Theme.spacing16)
                        .background(c.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                .stroke(showError ? Theme.errorColor : c.border, lineWidth: 1)
                        )
                        .cornerRadius(Theme.cornerRadius)

                        if showError {
                            Text(L10n.weightError(selectedLanguage))
                                .font(.ingredientText)
                                .foregroundColor(Theme.errorColor)
                        }
                    }

                    // Language segmented control
                    VStack(alignment: .leading, spacing: Theme.spacing8) {
                        Text(L10n.languageLabel(selectedLanguage).uppercased())
                            .font(.eyebrowMicro)
                            .foregroundColor(c.text3)
                            .tracking(0.12 * 9)

                        SegmentedControl(
                            options: AppLanguage.allCases,
                            selection: $selectedLanguage,
                            label: { $0.displayName },
                            colors: c
                        )
                    }
                }
                .frame(maxWidth: 360)

                // CTA Button
                Button(action: completeOnboarding) {
                    Text(L10n.continueButton(selectedLanguage).uppercased())
                        .font(.button)
                        .foregroundColor(c.bg)
                        .tracking(0.04 * 15)
                        .frame(maxWidth: 360)
                        .padding(.vertical, 15)
                        .background(Theme.accent)
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

// MARK: - Segmented Control

struct SegmentedControl<T: Hashable>: View {
    let options: [T]
    @Binding var selection: T
    let label: (T) -> String
    var colors: ThemeColorSet = Theme.colors(for: .dark)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button(action: { selection = option }) {
                    Text(label(option).uppercased())
                        .font(.bodySmallMedium)
                        .tracking(0.04 * 12)
                        .foregroundColor(selection == option ? colors.bg : colors.text2)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.spacing8)
                        .background(
                            selection == option ? Theme.accent : Color.clear
                        )
                        .cornerRadius(Theme.cornerRadiusSmall)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Theme.segmentedPadding)
        .background(colors.surface2)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(colors.border, lineWidth: 1)
        )
        .cornerRadius(Theme.cornerRadius)
    }
}
