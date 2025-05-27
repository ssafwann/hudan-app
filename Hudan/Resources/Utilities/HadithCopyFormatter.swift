import UIKit

struct HadithCopyFormatter {
    static func format(_ hadith: Hadith) -> String {
        """
        Narrated by \(hadith.narrator): "\(hadith.english)"

        Source: \(hadith.ref)
        In-book reference: \(hadith.inbook_ref)
        Grade: \(hadith.grade)
        """
    }
    
    static func copyToClipboard(_ hadith: Hadith) {
        UIPasteboard.general.string = format(hadith)
    }
} 
