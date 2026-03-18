import SwiftUI
import Combine

// MARK: - Language

enum AppLanguage: String, CaseIterable {
    case en
    case es

    var displayName: String {
        switch self {
        case .en: return "English"
        case .es: return "Español"
        }
    }

    var langCode: String { rawValue }
}

// MARK: - User Defaults Keys

enum UDKeys {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let userWeight = "userWeight"
    static let language = "language"
    static let appearance = "appearance"
}

// MARK: - App State

final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: UDKeys.hasCompletedOnboarding) }
    }

    @Published var userWeight: Double {
        didSet { UserDefaults.standard.set(userWeight, forKey: UDKeys.userWeight) }
    }

    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: UDKeys.language) }
    }

    @Published var appearance: AppearanceMode {
        didSet { UserDefaults.standard.set(appearance.rawValue, forKey: UDKeys.appearance) }
    }

    @Published var selectedTrainingType: TrainingType?

    // Current meal plan: [MealSlot: (quick: Meal, cooked: Meal)]
    @Published var currentMealPlan: [MealSlot: MealPair] = [:]

    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: UDKeys.hasCompletedOnboarding)

        let storedWeight = UserDefaults.standard.double(forKey: UDKeys.userWeight)
        self.userWeight = storedWeight > 0 ? storedWeight : 70.0

        if let langRaw = UserDefaults.standard.string(forKey: UDKeys.language),
           let lang = AppLanguage(rawValue: langRaw) {
            self.language = lang
        } else {
            self.language = .en
        }

        if let appRaw = UserDefaults.standard.string(forKey: UDKeys.appearance),
           let app = AppearanceMode(rawValue: appRaw) {
            self.appearance = app
        } else {
            self.appearance = .dark
        }
    }

    var themeColors: ThemeColors {
        Theme.colors(for: appearance)
    }

    func dailyTargets() -> MacroTargets? {
        selectedTrainingType?.dailyTargets(for: userWeight)
    }

    func actualMacros() -> (carbs: Int, protein: Int, fat: Int, kcal: Int) {
        var totalCarbs: Double = 0
        var totalProtein: Double = 0
        var totalFat: Double = 0
        var totalKcal: Double = 0

        for slot in MealSlot.allCases {
            if let pair = currentMealPlan[slot] {
                let meal = pair.quick
                let scaled = meal.scaledMacros(for: userWeight)
                totalCarbs += scaled.carbs
                totalProtein += scaled.protein
                totalFat += scaled.fat
                totalKcal += Double(meal.scaledKcal(for: userWeight))
            }
        }

        return (
            carbs: Int(totalCarbs.rounded()),
            protein: Int(totalProtein.rounded()),
            fat: Int(totalFat.rounded()),
            kcal: Int(totalKcal.rounded())
        )
    }
}

// MARK: - Meal Pair

struct MealPair {
    let quick: Meal
    let cooked: Meal
}
