import SwiftUI

struct HadithCard: View {
    let hadith: Hadith
    
    private var hadithContent: some View {
        Group {
            Text(hadith.arabic)
                .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: 26))
                .foregroundColor(Color("HadithText"))
                .multilineTextAlignment(.trailing)
                .lineSpacing(-1)
                .frame(maxWidth: .infinity, alignment: .trailing)

            Text("“\(hadith.english)”")
                .font(.custom("EBGaramond-Regular", size: 18))
                .foregroundColor(Color("HadithText"))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(4)
                .kerning(-0.1)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // Narrator
            Text("Narrated by \(hadith.narrator):")
                .font(.custom("HelveticaNeue-BoldItalic", size: 14))
                .foregroundStyle(Color("NText"))
                .frame(maxWidth: .infinity, alignment: .center)

            // Arabic + English text
            ViewThatFits(in: .vertical) {
                // Case 1: Content fits — no scroll
                VStack(alignment: .leading, spacing: 24) {
                    hadithContent
                }

                // Case 2: Content too big — enable scroll
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        hadithContent
                    }
                }
                .frame(maxHeight: 350)
            }
            
            Divider()
                .background(Color("DivClr"))
                .padding(.top, -4)

            // Source and Copy Button Row
            HStack {
                // Source and Reference
                VStack(alignment: .leading, spacing: 4) {
                    Text("Source: \(hadith.ref)")
                    Text("In-book Reference: \(hadith.inbook_ref)")
                    Text("Grade: \(hadith.grade)")
                }
                .font(.custom("HelveticaNeue", size: 11))
                .foregroundStyle(Color("LightText"))

                Spacer()

                // Copy Button
                Button(action: { HadithCopyFormatter.copyToClipboard(hadith) }) {
                    Text("Copy")
                        .font(.custom("HelveticaNeue", size: 12))
                        .foregroundColor(Color("UBtnContent"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color("UBtn"))
                        .clipShape(Capsule())
                }
            }
            .padding(.top, -8)
        }
        .padding(.horizontal, 24)
        .padding(.top, 36)
        .padding(.bottom, 24)
        .background(Color("CardBg"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
        )
    )
    .padding(.horizontal)
}
