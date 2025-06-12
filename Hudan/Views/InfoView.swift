import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    // Define font styles for consistency
    private var sectionTitleFont: Font { .custom("HelveticaNeue-Medium", size: 14) }
    private var paragraphFont: Font { .custom("HelveticaNeue", size: 14) }
    private var btnFont: Font { .custom("HelveticaNeue-Medium", size: 14) }
    private var subtextParagraphFont: Font { .custom("HelveticaNeue-Light", size: 14) }

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("MainBg"))
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.top, 10)
                        .background(Color("MainBg"))
                    ScrollView {
                        VStack(alignment: .leading, spacing: 35) {
                            // DAILY HADITH Section (Corrected from DAILY VERSE)
                            VStack(alignment: .leading, spacing: 15) {
                                Text("DAILY HADITH")
                                    .font(sectionTitleFont)
                                    .foregroundStyle(.black)
                                    .tracking(0.4)
                                Text("Hudan is an app with the intention of provide an easy way for Muslims to implement the words and action of our Prophet Muhammad ﷺ. A daily hadith is shown on both the app & widget, with all content being sourced from Sunnah.com.")
                                    .font(paragraphFont)
                                    .foregroundStyle(.black)
                                    .lineSpacing(4)
                            }
                            
                            // WIDGET CUSTOMIZATION Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("WIDGET CUSTOMIZATION")
                                    .font(sectionTitleFont)
                                    .foregroundStyle(.black)
                                    .tracking(0.4)
                                Text("Personalize your widget experience! You can choose from several beautiful default backgrounds provided within the app, and change the text display settings to your likings.")
                                    .font(paragraphFont)
                                    .foregroundStyle(.black)
                                    .lineSpacing(4)
                                
                               /*
                                Text("The only paid feature in Hudan is the ability to set your own custom image as the widget background. This optional customization is available for a one-time, nominal fee of $5.99.")
                                    .font(subtextParagraphFont)
                                    .foregroundColor(Color("AppDarkText"))
                                    .lineSpacing(4)
                                */
                            }
                            
                            // FEEDBACK & SUGGESTIONS Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("FEEDBACK & SUGGESTIONS")
                                    .font(sectionTitleFont)
                                    .foregroundStyle(.black)
                                    .tracking(0.4)
                                Text("Have ideas on how to improve Hudan? Or came across a bug? Please contact us below.")
                                    .font(paragraphFont)
                                    .foregroundStyle(.black)
                                    .lineSpacing(4)
                                LinkButton(title: "Submit Feedback", urlString: "https://yourappfeedbacklink.com", fontStyle: btnFont)
                            }
                            
                            // RATE NUR Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("RATE THE APP")
                                    .font(sectionTitleFont)
                                    .foregroundStyle(.black)
                                    .tracking(0.4)
                                Text("If you find Hudan beneficial, please consider leaving a rating on the App Store. Your support helps others discover the app!")
                                    .font(paragraphFont)
                                    .foregroundStyle(.black)
                                    .lineSpacing(4)
                                LinkButton(title: "Rate on App Store", urlString: "https://yourappstorelink.com", fontStyle: btnFont)
                            }
                            
                            // ABOUT Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("ABOUT")
                                    .font(sectionTitleFont)
                                    .foregroundStyle(.black)
                                    .tracking(0.4)
                                Text("Hudan is built with care by me, Malik Safwan. To see more of my work or to connect with me, check out my Twitter.")
                                    .font(paragraphFont)
                                    .foregroundStyle(.black)
                                    .lineSpacing(4)
                                LinkButton(title: "Visit My Twitter", urlString: "https://x.com/safwanmalikkk", fontStyle: btnFont)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .background(Color("MainBg"))
                    }
                }
                .padding(.bottom, 10)
                .navigationTitle("Information")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                dismiss()
                            }
                        }) {
                            Image("chev")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(Color("AppDarkText"))
                        }
                    }
                }
                .background(Color("MainBg"))

            }
            .navigationViewStyle(.stack)
        }
        .padding(.top, 30)
        .background(Color("MainBg").ignoresSafeArea())
    }
}

// Helper view for the Link buttons to match the style
struct LinkButton: View {
    let title: String
    let urlString: String
    let fontStyle: Font // Added to accept font style

    var body: some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                HStack(spacing: 4) {
                    Text(title)
                        .font(fontStyle) // Use passed font style
                    Image("ExtBtn")
                        .resizable()
                          .frame(width: 18, height: 18)
                }
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                .background(Color("ExternalBtn"))
                .cornerRadius(8)
                .foregroundColor(Color("NText"))
            }
        }
    }
}

#Preview {
    InfoView()
}
