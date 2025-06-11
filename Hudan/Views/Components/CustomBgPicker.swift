import SwiftUI

struct CustomBgPicker: View {
    let isFeatureUnlocked: Bool
    var onSelect: () -> Void // Closure to call when unlocked
    var onLock: () -> Void   // Closure to call when locked

    var body: some View {
        Button(action: {
            if isFeatureUnlocked {
                onSelect()
            } else {
                onLock()
            }
        }) {
            HStack(spacing: 8) {
                if !isFeatureUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("PrimaryGreen"))
                }
                Text("Set custom background")
            }
            .font(.custom("HelveticaNeue-Medium", size: 12))
            .foregroundColor(Color("HadithText"))
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .background(Color("CustomBgBtn"))
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CustomBgPicker(isFeatureUnlocked: false, onSelect: {}, onLock: {})
}

