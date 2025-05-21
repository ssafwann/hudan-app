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
        loadLastHadithID()
        selectDailyHadith()
    }
    
    private func loadHadiths() {
        guard let url = Bundle.main.url(forResource: "hadiths", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to locate or load hadiths.json")
            return
        }
        
        do {
            allHadiths = try JSONDecoder().decode([Hadith].self, from: data)
            print("Successfully loaded \(allHadiths.count) hadiths")
        } catch {
            print("Error decoding hadiths: \(error)")
        }
    }
    
    private func loadLastHadithID() {
        lastHadithID = UserDefaults.standard.integer(forKey: lastHadithIDKey)
    }
    
    func selectDailyHadith() {
        guard !allHadiths.isEmpty else { return }
        
        // Get the current date in UTC
        let currentDate = getCurrentUTCDate()
        
        // Check if we need to select a new hadith (if it's a new day in UTC)
        if shouldSelectNewHadith(currentUTCDate: currentDate) {
            // Select a new random hadith that's different from the last one
            let newHadith = getRandomHadithExcluding(id: lastHadithID)
            currentHadith = newHadith
            
            // Save the new hadith ID and update date
            lastHadithID = newHadith.id
            UserDefaults.standard.set(lastHadithID, forKey: lastHadithIDKey)
            UserDefaults.standard.set(currentDate, forKey: lastUpdateDateKey)
        } else {
            // If it's the same day, try to find the previously selected hadith
            if lastHadithID >= 0 {
                currentHadith = allHadiths.first(where: { $0.id == lastHadithID }) 
            }
            
            // If we can't find the previous hadith (or none was selected), just pick a random one
            if currentHadith == nil {
                currentHadith = getRandomHadithExcluding(id: -1)
                lastHadithID = currentHadith?.id ?? -1
                UserDefaults.standard.set(lastHadithID, forKey: lastHadithIDKey)
            }
        }
    }
    
    // Get a random hadith excluding the one with the specified ID
    private func getRandomHadithExcluding(id: Int) -> Hadith {
        if allHadiths.count <= 1 {
            return allHadiths[0] // If there's only one hadith, return it
        }
        
        // Filter out the hadith with the excluded ID
        let availableHadiths = allHadiths.filter { $0.id != id }
        let randomIndex = Int.random(in: 0..<availableHadiths.count)
        
        return availableHadiths[randomIndex]
    }
    
    // Check if we need to select a new hadith based on UTC date
    private func shouldSelectNewHadith(currentUTCDate: Date) -> Bool {
        guard let lastUpdateDate = UserDefaults.standard.object(forKey: lastUpdateDateKey) as? Date else {
            // If there's no last update date, we should select a new hadith
            return true
        }
        
        // Get the date components for both dates in UTC
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentUTCDate)
        let lastComponents = calendar.dateComponents([.year, .month, .day], from: lastUpdateDate)
        
        // If any of the components are different, it's a new day
        return currentComponents.year != lastComponents.year ||
               currentComponents.month != lastComponents.month ||
               currentComponents.day != lastComponents.day
    }
    
    // Get the current date in UTC
    private func getCurrentUTCDate() -> Date {
        let now = Date()
        let utcCalendar = Calendar.current
        var utcComponents = utcCalendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: now)
        
        // Create a new date with UTC components
        return utcCalendar.date(from: utcComponents) ?? now
    }
    
    // Get a random hadith (useful for manual refresh)
    func getRandomHadith() -> Hadith? {
        guard !allHadiths.isEmpty else { return nil }
        
        // Select a random hadith, but avoid the current one to prevent getting the same one again
        let randomIndex = Int.random(in: 0..<allHadiths.count)
        let randomHadith = allHadiths[randomIndex]
        
        if randomHadith.id == currentHadith?.id && allHadiths.count > 1 {
            // If we got the current hadith and there's more than one, try again
            return getRandomHadith()
        }
        
        return randomHadith
    }
}


