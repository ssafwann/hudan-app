import Foundation
import SwiftUI

@Observable final class HadithService {
    private(set) var allHadiths: [Hadith] = []
    private(set) var currentHadith: Hadith?
    
    // Track the last selected hadith ID to avoid repetition
    private var lastHadithID: Int = -1
    
    // Key for storing the last hadith ID in UserDefaults
    private let lastHadithIDKey = "lastHadithID"
    private let lastUpdateDateKey = "lastUpdateDate"
    
    init() {
        loadHadiths()
        selectDailyHadith()
    }
    
    private func loadHadiths() {
        guard let url = Bundle.main.url(forResource: "hadiths", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to locate or load hadiths.json")
            return
        }
        
        do {
            var loadedHadiths = try JSONDecoder().decode([Hadith].self, from: data)
            // Sort by ID to ensure consistent order for deterministic selection
            loadedHadiths.sort { $0.id < $1.id }
            self.allHadiths = loadedHadiths
            print("Successfully loaded and sorted \(allHadiths.count) hadiths")
        } catch {
            print("Error decoding hadiths: \(error)")
        }
    }
    
    func selectDailyHadith() {
        guard !allHadiths.isEmpty else {
            currentHadith = nil
            return
        }

        let currentUTCDate = getCurrentUTCDate()
        // Use Gregorian calendar for consistent day of year calculation
        let calendar = Calendar(identifier: .gregorian)
        
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentUTCDate) ?? 1

        let hadithCount = allHadiths.count
        // Calculate a 0-based index. (dayOfYear - 1) because dayOfYear is 1-based.
        // Ensure hadithCount is not zero to prevent division by zero if allHadiths is empty
        // (though guarded above, this is an extra safety for the modulo).
        let selectedIndex = hadithCount > 0 ? (dayOfYear - 1) % hadithCount : 0


        if hadithCount > 0 {
            let newSelectedHadith = allHadiths[selectedIndex]
            self.currentHadith = newSelectedHadith

            UserDefaults.standard.set(newSelectedHadith.id, forKey: lastHadithIDKey)
            self.lastHadithID = newSelectedHadith.id // Update internal state if needed

            let lastStoredUpdateDate = UserDefaults.standard.object(forKey: lastUpdateDateKey) as? Date
            var shouldSaveNewUpdateDate = true
            if let lastDate = lastStoredUpdateDate {
                if calendar.isDate(lastDate, inSameDayAs: currentUTCDate) {
                    shouldSaveNewUpdateDate = false
                }
            }

            if shouldSaveNewUpdateDate {
                UserDefaults.standard.set(currentUTCDate, forKey: lastUpdateDateKey)
            }
        } else {
            // Fallback if allHadiths is empty after the initial guard (should not happen)
            currentHadith = nil
        }
    }
    
    // Get the current date in UTC
    private func getCurrentUTCDate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! 
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components) ?? Date() // Fallback
    }
}


