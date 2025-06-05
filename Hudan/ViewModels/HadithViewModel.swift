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
    
    
    // Utility: Get hadith by ID
    func getHadith(by id: Int) -> Hadith? {
        return allHadiths.first(where: { $0.id == id })
    }
    
    // Copy hadith text to clipboard
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
}
