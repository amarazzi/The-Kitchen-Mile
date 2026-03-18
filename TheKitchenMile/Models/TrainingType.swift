import SwiftUI

// MARK: - Training Type

enum TrainingType: String, Codable, CaseIterable {
    case easy
    case quality
    case longRun
    case rest

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
            case .easy: return "Easy Run"
            case .quality: return "Quality Session"
            case .longRun: return "Long Run"
            case .rest: return "Rest Day"
            }
        case .es:
            switch self {
            case .easy: return "Trote Suave"
            case .quality: return "Calidad"
            case .longRun: return "Fondo Largo"
            case .rest: return "Descanso"
            }
        }
    }

    func shortName(lang: AppLanguage) -> String {
        switch lang {
        case .en:
            switch self {
            case .easy: return "Easy Run"
            case .quality: return "Quality"
            case .longRun: return "Long Run"
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

    func eyebrowLabel(lang: AppLanguage) -> String {
        switch lang {
        case .en:
            switch self {
            case .easy: return "Workout"
            case .quality: return "Workout"
            case .longRun: return "Endurance"
            case .rest: return "Recovery"
            }
        case .es:
            switch self {
            case .easy: return "Entrenamiento"
            case .quality: return "Entrenamiento"
            case .longRun: return "Resistencia"
            case .rest: return "Recuperación"
            }
        }
    }

    func subtitle(lang: AppLanguage) -> String {
        switch lang {
        case .en:
            switch self {
            case .easy: return "Low intensity, steady pace"
            case .quality: return "Intervals, tempo, speed"
            case .longRun: return "High mileage endurance"
            case .rest: return "Recovery and restoration"
            }
        case .es:
            switch self {
            case .easy: return "Baja intensidad, ritmo estable"
            case .quality: return "Intervalos, tempo, velocidad"
            case .longRun: return "Kilometraje largo, fondo"
            case .rest: return "Recuperación y descanso"
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
