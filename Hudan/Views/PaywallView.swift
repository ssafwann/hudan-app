import SwiftUI

struct PaywallView: View {
    // This action will be passed from the parent view to dismiss this sheet.
    var onDismiss: () -> Void
    // This action will be called when the user 'successfully' purchases.
    var onPurchaseSuccess: () -> Void
    
    @State private var gifData: Data?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 25) {
            // Header with Close Button
            HStack {
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("UBtnContent"))
                        .clipShape(Circle())
                }
            }.padding(.bottom, -15)
            
            // Main Content
            VStack(spacing: 15) {
                Text("Unlock Custom Backgrounds")
                    .font(.custom("HelveticaNeue-Medium", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color("HadithText"))
                
                Text("Personalize your widget with any image from your photo library.")
                    .font(.custom("HelveticaNeue-Light", size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tracking(0.6)
                    .lineSpacing(1)

            }

            // GIF View with Placeholder
            ZStack {
                // Placeholder view
                Color(.systemGray6)
                ProgressView()

                // The GIFView will appear once the data is loaded
                if let gifData {
                    GIFView(data: gifData)
                }
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(20)

            // Feature List
            VStack(alignment: .leading, spacing: 15) {
                FeatureView(text: "Custom widget backgrounds")
                FeatureView(text: "Unlimited access to future updates")
                FeatureView(text: "Support further development")
            }

            // Action Buttons
            VStack(spacing: 25) {
                Button(action: onPurchaseSuccess) {
                    Text("Unlock Premium")
                        .font(.custom("HelveticaNeue-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("SecondaryGreen"))
                        .cornerRadius(30)
                }
                
                Button(action: {
                    PurchaseManager.shared.restorePurchases()
                }) {
                    Text("Restore Purchases")
                        .font(.custom("HelveticaNeue-Light", size: 14))
                        .foregroundColor(Color("AppDarkText"))
                        .tracking(0.6)

                }
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 40)
        .padding(.top, 25)
        .background(Color("AppWhite"))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .onAppear(perform: loadGIF)
    }
    
    private func loadGIF() {
        // Load the GIF data asynchronously to avoid blocking the UI
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "paywall", withExtension: "gif"),
                  let data = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                self.gifData = data
            }
        }
    }
}

// Helper view for the feature list items
private struct FeatureView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color("CheckIcon"))
                .font(.system(size: 20))
            
            Text(text)
                .font(.custom("HelveticaNeue-Light", size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .tracking(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.gray
        PaywallView(onDismiss: {}, onPurchaseSuccess: { PurchaseManager.shared.purchase() })
    }
}
