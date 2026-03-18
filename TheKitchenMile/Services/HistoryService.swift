import Foundation

// MARK: - History Entry

struct HistoryEntry: Codable {
    let mealID: String
    let slot: MealSlot
    let mode: MealMode
    let timestamp: Date
}

// MARK: - History Service

final class HistoryService: ObservableObject {
    private let fileName = "meal_history.json"
    private let retentionDays: Int = 3

    @Published private(set) var entries: [HistoryEntry] = []

    init() {
        loadHistory()
        purgeOldEntries()
    }

    // MARK: - File Path

    private var historyFileURL: URL {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!

        let appDir = appSupport.appendingPathComponent("TheKitchenMile", isDirectory: true)

        if !FileManager.default.fileExists(atPath: appDir.path) {
            try? FileManager.default.createDirectory(
                at: appDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

        return appDir.appendingPathComponent(fileName)
    }

    // MARK: - Load / Save

    private func loadHistory() {
        let url = historyFileURL
        guard FileManager.default.fileExists(atPath: url.path) else { return }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            entries = try decoder.decode([HistoryEntry].self, from: data)
        } catch {
            print("[HistoryService] Failed to load history: \(error)")
            entries = []
        }
    }

    private func saveHistory() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(entries)
            try data.write(to: historyFileURL, options: .atomic)
        } catch {
            print("[HistoryService] Failed to save history: \(error)")
        }
    }

    // MARK: - Purge

    func purgeOldEntries() {
        let cutoff = Calendar.current.date(
            byAdding: .day,
            value: -retentionDays,
            to: Date()
        )!

        let before = entries.count
        entries.removeAll { $0.timestamp < cutoff }

        if entries.count != before {
            saveHistory()
        }
    }

    // MARK: - Record

    func record(mealID: String, slot: MealSlot, mode: MealMode) {
        let entry = HistoryEntry(
            mealID: mealID,
            slot: slot,
            mode: mode,
            timestamp: Date()
        )
        entries.append(entry)
        saveHistory()
    }

    func recordPair(_ pair: MealPair, slot: MealSlot) {
        record(mealID: pair.quick.id, slot: slot, mode: .quick)
        record(mealID: pair.cooked.id, slot: slot, mode: .cooked)
    }

    // MARK: - Query

    func recentMealIDs(for slot: MealSlot, mode: MealMode) -> Set<String> {
        let cutoff = Calendar.current.date(
            byAdding: .day,
            value: -retentionDays,
            to: Date()
        )!

        let ids = entries
            .filter { $0.slot == slot && $0.mode == mode && $0.timestamp >= cutoff }
            .map { $0.mealID }

        return Set(ids)
    }
}
