// hadith data model

import Foundation

struct Hadith: Identifiable, Codable {
    let id: Int
    let narrator: String
    let arabic: String
    let english: String
    let summary: String
    let ref: String
    let inbook_ref: String
    let grade: String
}
