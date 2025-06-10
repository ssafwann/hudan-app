import SwiftUI

struct PaywallView: View {
    // This action will be passed from the parent view to dismiss this sheet.
    var onDismiss: () -> Void
    // This action will be called when the user 'successfully' purchases.
    var onPurchaseSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with Close Button
            HStack {
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color("HadithText"))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            
            // Main Content
            VStack(spacing: 15) {
                Text("Unlock Custom Backgrounds")
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                    .foregroundColor(Color("HadithText"))
                
                Text("Personalize your widget with any image from your photo library.")
                    .font(.custom("HelveticaNeue-Regular", size: 16))
                    .foregroundColor(Color("LightText"))
                    .multilineTextAlignment(.center)
            }

            // Image Placeholder
            Image("bg1") // Using bg1 as a placeholder for the GIF
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .cornerRadius(20)

            // Feature List
            VStack(alignment: .leading, spacing: 15) {
                FeatureView(text: "Custom widget backgrounds")
                FeatureView(text: "Unlimited access to future updates")
                FeatureView(text: "Support further development")
            }
            .padding(.horizontal, 10)

            Spacer()

            // Action Buttons
            VStack(spacing: 15) {
                Button(action: onPurchaseSuccess) {
                    Text("Unlock Premium")
                        .font(.custom("HelveticaNeue-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("SecondaryGreen"))
                        .cornerRadius(14)
                }
                
                Button(action: {
                    // Placeholder for restore action
                    print("Restore Purchases tapped")
                }) {
                    Text("Restore Purchases")
                        .font(.custom("HelveticaNeue-Medium", size: 16))
                        .foregroundColor(Color("HadithText"))
                }
            }
        }
        .padding(25)
        .background(Color("White"))
        .cornerRadius(25)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}

// Helper view for the feature list items
private struct FeatureView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color("SecondaryGreen"))
                .font(.system(size: 20))
            
            Text(text)
                .font(.custom("HelveticaNeue-Medium", size: 16))
                .foregroundColor(Color("HadithText"))
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        PaywallView(onDismiss: {}, onPurchaseSuccess: {})
    }
}
