import SwiftUI

// MARK: - Training Type

enum TrainingType: String, Codable, CaseIterable {
    case easy
    case quality
    case longRun
    case rest

    var color: Color {
        switch self {
        case .easy: return Theme.easyRunColor
        case .quality: return Theme.qualityColor
        case .longRun: return Theme.longRunColor
        case .rest: return Theme.restDayColor
        }
    }

    // Macros per kg of body weight
    var carbsPerKg: Double {
        switch self {
        case .easy: return 3.6
        case .quality: return 4.4
        case .longRun: return 5.0
        case .rest: return 3.0
        }
    }

    var proteinPerKg: Double {
        switch self {
        case .easy: return 2.0
        case .quality: return 2.0
        case .longRun: return 2.0
        case .rest: return 2.0
        }
    }

    var fatPerKg: Double {
        switch self {
        case .easy: return 0.9
        case .quality: return 0.9
        case .longRun: return 1.0
        case .rest: return 1.0
        }
    }

    func dailyTargets(for weight: Double) -> MacroTargets {
        MacroTargets(
            carbs: Int((carbsPerKg * weight).rounded()),
            protein: Int((proteinPerKg * weight).rounded()),
            fat: Int((fatPerKg * weight).rounded())
        )
    }

    func displayName(lang: AppLanguage) -> String {
        switch lang {
        case .en:
            switch self {
            case .easy: return "Easy run"
            case .quality: return "Quality session"
            case .longRun: return "Long run"
            case .rest: return "Rest day"
            }
        case .es:
            switch self {
            case .easy: return "Trote suave"
            case .quality: return "Calidad"
            case .longRun: return "Fondo largo"
            case .rest: return "Descanso"
            }
        }
    }

    func shortName(lang: AppLanguage) -> String {
        switch lang {
        case .en:
            switch self {
            case .easy: return "Easy run"
            case .quality: return "Quality"
            case .longRun: return "Long run"
            case .rest: return "Rest"
            }
        case .es:
            switch self {
            case .easy: return "Trote"
            case .quality: return "Calidad"
            case .longRun: return "Fondo"
            case .rest: return "Descanso"
            }
        }
    }
}

// MARK: - Macro Targets

struct MacroTargets {
    let carbs: Int
    let protein: Int
    let fat: Int

    var totalKcal: Int {
        (carbs * 4) + (protein * 4) + (fat * 9)
    }
}
