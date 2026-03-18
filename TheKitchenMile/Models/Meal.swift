import Foundation

// MARK: - Meal Ingredient

struct MealIngredient: Codable, Identifiable {
    let item: String
    let amount: Double
    let unit: String

    var id: String { item }

    func scaled(for weight: Double) -> MealIngredient {
        let factor = weight / 70.0
        return MealIngredient(
            item: item,
            amount: (amount * factor).rounded(),
            unit: unit
        )
    }

    func displayAmount() -> String {
        let intAmount = Int(amount.rounded())
        return "\(intAmount)\(unit)"
    }
}

// MARK: - Meal Macros

struct MealMacros: Codable {
    let carbs: Double
    let protein: Double
    let fat: Double

    func scaled(for weight: Double) -> MealMacros {
        let factor = weight / 70.0
        return MealMacros(
            carbs: (carbs * factor).rounded(),
            protein: (protein * factor).rounded(),
            fat: (fat * factor).rounded()
        )
    }
}

// MARK: - Meal Mode

enum MealMode: String, Codable, CaseIterable {
    case quick
    case cooked
}

// MARK: - Meal Slot

enum MealSlot: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case snack
    case dinner
}

// MARK: - Meal

struct Meal: Codable, Identifiable {
    let id: String
    let lang: String
    let meal: MealSlot
    let trainingType: TrainingType
    let mode: MealMode
    let name: String
    let ingredients: [MealIngredient]
    let prepNote: String
    let kcal: Double
    let macros: MealMacros

    func scaledKcal(for weight: Double) -> Int {
        let factor = weight / 70.0
        return Int((kcal * factor).rounded())
    }

    func scaledIngredients(for weight: Double) -> [MealIngredient] {
        ingredients.map { $0.scaled(for: weight) }
    }

    func scaledMacros(for weight: Double) -> MealMacros {
        macros.scaled(for: weight)
    }
}
