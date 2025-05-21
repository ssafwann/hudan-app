// ViewModel to handle hadith display logic

import Foundation
import SwiftUI

@Observable final class HadithViewModel {
    private let hadithService: HadithService
    private(set) var isLoading: Bool = false
    private(set) var hasError: Bool = false
    private(set) var errorMessage: String = ""
    
    // Computed property to access the current hadith
    var currentHadith: Hadith? {
        return hadithService.currentHadith
    }
    
    // Access to all hadiths if needed
    var allHadiths: [Hadith] {
        return hadithService.allHadiths
    }
    
    // Initialize with a new HadithService instance
    init() {
        self.hadithService = HadithService()
    }
    
    // Initialize with a provided HadithService (useful for testing or dependency injection)
    init(hadithService: HadithService) {
        self.hadithService = hadithService
    }
    
    // Refresh the current hadith (reselect the daily hadith)
    func refreshHadith() {
        isLoading = true
        hasError = false
        
        // Short delay to allow UI to show loading state if needed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            do {
                self.hadithService.selectDailyHadith()
                self.isLoading = false
            } catch {
                self.hasError = true
                self.errorMessage = "Failed to refresh hadith: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    // Get a random hadith (different from the current one)
    func getRandomHadith() -> Hadith? {
        isLoading = true
        let randomHadith = hadithService.getRandomHadith()
        isLoading = false
        return randomHadith
    }
    
    // Utility: Format the current date for display
    func formattedCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy"
        return formatter.string(from: Date())
    }
    
    // Utility: Get hadith by ID
    func getHadith(by id: Int) -> Hadith? {
        return allHadiths.first(where: { $0.id == id })
    }
    
    // Copy hadith text to clipboard
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}
