import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // DAILY VERSE Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DAILY VERSE")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Nur displays a verse from the Holy Qur\'an. You can customize the verse displayed in the widget by tapping the \"Another Verse\" button, or setting a specific verse to be displayed in the widget.")
                            .font(.subheadline)
                    }

                    // WIDGET CUSTOMIZATION Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("WIDGET CUSTOMIZATION")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Personalize your widget experience! You can choose from several beautiful default backgrounds provided within the app.")
                            .font(.subheadline)
                        Text("The only paid feature in Nur is the ability to set your own custom image as the widget background. We believe in keeping core features accessible — this optional customization is available for a one-time, nominal fee of $5.99.")
                            .font(.subheadline)
                        Text("Consider subscribing to support the ongoing development and maintenance of Nur.")
                            .font(.subheadline)
                    }

                    // FEEDBACK & SUGGESTIONS Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FEEDBACK & SUGGESTIONS")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Have ideas on how to improve Nur? We\'d love to hear from you!")
                            .font(.subheadline)
                        LinkButton(title: "Submit Feedback", urlString: "https://yourappfeedbacklink.com") // Replace with actual URL
                    }

                    // RATE NUR Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RATE NUR")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("If you find Nur beneficial, please consider leaving a rating on the App Store. Your support helps others discover the app!")
                            .font(.subheadline)
                        LinkButton(title: "Rate on App Store", urlString: "https://yourappstorelink.com") // Replace with actual URL
                    }

                    // ABOUT Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ABOUT")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Nur is built with care by Fajr Labs. We focus on creating simple, beautiful applications that benefit Muslims in their daily lives.")
                            .font(.subheadline)
                        LinkButton(title: "Visit Fajr Labs", urlString: "https://fajrlabslink.com") // Replace with actual URL
                    }
                }
                .padding()
            }
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
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary) // Ensure good visibility
                    }
                }
            }
        }
    }
}

// Helper view for the Link buttons to match the style
struct LinkButton: View {
    let title: String
    let urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                }
                .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    InfoView()
}
