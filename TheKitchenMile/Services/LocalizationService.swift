import Foundation

// MARK: - Localized Strings

enum L10n {
    // MARK: - Onboarding
    static func onboardingTitle(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Setup"
        case .es: return "Configuración"
        }
    }

    static func weightLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "How much do you weigh?"
        case .es: return "¿Cuánto pesás?"
        }
    }

    static func weightUnit(_ lang: AppLanguage) -> String {
        return "kg"
    }

    static func weightPlaceholder(_ lang: AppLanguage) -> String {
        return "70"
    }

    static func weightError(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Enter a value between 50 and 120 kg"
        case .es: return "Ingresá un valor entre 50 y 120 kg"
        }
    }

    static func languageLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Language"
        case .es: return "Idioma"
        }
    }

    static func continueButton(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Continue"
        case .es: return "Continuar"
        }
    }

    // MARK: - Training Selection
    static func trainingQuestion(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "What's your training today?"
        case .es: return "¿Qué entrenás hoy?"
        }
    }

    // MARK: - Meal Plan
    static func breakfast(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Breakfast"
        case .es: return "Desayuno"
        }
    }

    static func lunch(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Lunch"
        case .es: return "Almuerzo"
        }
    }

    static func snack(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Snack"
        case .es: return "Merienda"
        }
    }

    static func dinner(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Dinner"
        case .es: return "Cena"
        }
    }

    static func slotName(_ slot: MealSlot, lang: AppLanguage) -> String {
        switch slot {
        case .breakfast: return breakfast(lang)
        case .lunch: return lunch(lang)
        case .snack: return snack(lang)
        case .dinner: return dinner(lang)
        }
    }

    static func quick(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Quick"
        case .es: return "Rápido"
        }
    }

    static func cooked(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Cooked"
        case .es: return "Cocinado"
        }
    }

    // MARK: - Macro Bar
    static func carbsLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Carbs"
        case .es: return "Carbos"
        }
    }

    static func proteinLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Protein"
        case .es: return "Proteína"
        }
    }

    static func fatLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Fat"
        case .es: return "Grasa"
        }
    }

    static func targetLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "target"
        case .es: return "objetivo"
        }
    }

    // MARK: - Settings
    static func settingsTitle(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Settings"
        case .es: return "Ajustes"
        }
    }

    static func appearanceLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Appearance"
        case .es: return "Apariencia"
        }
    }

    static func darkLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Dark"
        case .es: return "Oscuro"
        }
    }

    static func lightLabel(_ lang: AppLanguage) -> String {
        switch lang {
        case .en: return "Light"
        case .es: return "Claro"
        }
    }
}
