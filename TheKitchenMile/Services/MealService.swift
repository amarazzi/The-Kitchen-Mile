import Foundation

// MARK: - Meal Service

final class MealService {
    static let shared = MealService()

    private var allMeals: [Meal] = []

    private init() {
        loadMeals()
    }

    private func loadMeals() {
        guard let url = Bundle.main.url(forResource: "meals", withExtension: "json") else {
            print("[MealService] meals.json not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allMeals = try decoder.decode([Meal].self, from: data)
            print("[MealService] Loaded \(allMeals.count) meals")
        } catch {
            print("[MealService] Failed to decode meals.json: \(error)")
        }
    }

    func meals(
        lang: String,
        slot: MealSlot,
        trainingType: TrainingType,
        mode: MealMode
    ) -> [Meal] {
        allMeals.filter {
            $0.lang == lang &&
            $0.meal == slot &&
            $0.trainingType == trainingType &&
            $0.mode == mode
        }
    }

    func randomMeal(
        lang: String,
        slot: MealSlot,
        trainingType: TrainingType,
        mode: MealMode,
        excluding excludedIDs: Set<String>
    ) -> Meal? {
        let candidates = meals(lang: lang, slot: slot, trainingType: trainingType, mode: mode)
            .filter { !excludedIDs.contains($0.id) }

        if candidates.isEmpty {
            // Fallback: pick from all meals for this slot/type/mode ignoring exclusion
            return meals(lang: lang, slot: slot, trainingType: trainingType, mode: mode).randomElement()
        }

        return candidates.randomElement()
    }

    func generateMealPair(
        lang: String,
        slot: MealSlot,
        trainingType: TrainingType,
        excludedQuickIDs: Set<String>,
        excludedCookedIDs: Set<String>
    ) -> MealPair? {
        guard let quick = randomMeal(
            lang: lang,
            slot: slot,
            trainingType: trainingType,
            mode: .quick,
            excluding: excludedQuickIDs
        ),
        let cooked = randomMeal(
            lang: lang,
            slot: slot,
            trainingType: trainingType,
            mode: .cooked,
            excluding: excludedCookedIDs
        ) else {
            return nil
        }

        return MealPair(quick: quick, cooked: cooked)
    }

    func generateFullPlan(
        lang: String,
        trainingType: TrainingType,
        historyService: HistoryService
    ) -> [MealSlot: MealPair] {
        var plan: [MealSlot: MealPair] = [:]

        for slot in MealSlot.allCases {
            let excludedQuick = historyService.recentMealIDs(for: slot, mode: .quick)
            let excludedCooked = historyService.recentMealIDs(for: slot, mode: .cooked)

            if let pair = generateMealPair(
                lang: lang,
                slot: slot,
                trainingType: trainingType,
                excludedQuickIDs: excludedQuick,
                excludedCookedIDs: excludedCooked
            ) {
                plan[slot] = pair
            }
        }

        return plan
    }
}
