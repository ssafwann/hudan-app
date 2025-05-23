// Hadith display component

import SwiftUI

struct HadithCard: View {
    let hadith: Hadith
    var onCopyTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Narrator
            Text("Narrated by \(hadith.narrator):")
                .font(.custom("HelveticaNeue", size: 16))
                .foregroundStyle(.secondary)
            
            // Arabic Text
            Text(hadith.arabic)
                .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: 24))
                .foregroundColor(Color("HadithText"))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // English Translation
            Text(hadith.english)
                .font(.custom("EBGaramond-Regular", size: 18))
                .foregroundColor(Color("HadithText"))
                .fixedSize(horizontal: false, vertical: true)
            
            // Source and Reference
            VStack(alignment: .leading, spacing: 4) {
                Text("Source: \(hadith.ref)")
                Text("In-book Reference: \(hadith.inbook_ref)")
                Text("Grade: \(hadith.grade)")
            }
            .font(.custom("HelveticaNeue", size: 14))
            .foregroundStyle(.secondary)
            
            // Copy Button
            Button(action: onCopyTapped) {
                Text("Copy")
                    .font(.custom("HelveticaNeue", size: 16))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(24)
        .background(Color(.systemBackground))
    }
}

#Preview {
    HadithCard(
        hadith: Hadith(
            id: 5971,
            narrator: "Abu Hurairah",
            arabic: "جَاءَ رَجُلٌ إِلَى رَسُولِ اللَّهِ صلى الله عليه وسلم فَقَالَ يَا رَسُولَ اللَّهِ مَنْ أَحَقُّ بِحُسْنِ صَحَابَتِي قَالَ \" أُمُّكَ \" . قَالَ ثُمَّ مَنْ قَالَ \" أُمُّكَ \" . قَالَ ثُمَّ مَنْ قَالَ \" أُمُّكَ \" . قَالَ ثُمَّ مَنْ قَالَ \" ثُمَّ أَبُوكَ \"",
            english: "A man came to Allah's Messenger (ﷺ) and said, O Allah's Messenger (ﷺ)! Who is more entitled to be treated with the best companionship by me? The Prophet (ﷺ) said, Your mother. The man said, Who is next? The Prophet said, Your mother. The man further said, Who is next? The Prophet said, Your mother. The man asked for the fourth time, Who is next? The Prophet said, Your father.",
            summary: "The importance of treating one's mother with the best companionship",
            ref: "Sahih al-Bukhari 5971",
            inbook_ref: "Book 78, Hadith 1",
            grade: "Sahih (authentic)"
        ),
        onCopyTapped: {}
    )
}
