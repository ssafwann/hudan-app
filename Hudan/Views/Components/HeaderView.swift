// Header for the home screen

import SwiftUI

struct HeaderView: View {
    var dateString: String
    var onSettingsTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            // Left column - date, title, and tagline
            VStack(alignment: .leading, spacing: 0) {
                // Date with calendar icon
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("SecondaryGreen"))
                        .font(.system(size: 14))
                    
                    Text(dateString)
                        .font(.custom("HelveticaNeue-Regular", size: 16))
                        .foregroundColor(Color("LightText"))
                }
                .padding(.bottom, 8)
                
                // Title
                Text("Today's Hadith")
                    .font(.custom("HelveticaNeue-Medium", size: 32))
                    .foregroundColor(Color("PrimaryGreen"))
                    .padding(.bottom, 6)
                    .accessibilityAddTraits(.isHeader)
                
                // Tagline
                Text("Gain wisdom from the words and actions of our Prophet Muhammad ﷺ")
                    .font(.custom("HelveticaNeue", size: 16))
                    .foregroundColor(Color("DarkText"))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Right column - settings button (aligned to top)
            Button(action: onSettingsTapped) {
                Image(systemName: "gear")
                    .font(.system(size: 20))
                    .foregroundColor(Color("UBtnContent"))
                    .frame(width: 40, height: 40)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Circle())
            }
            .accessibilityLabel("Settings")
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    VStack {
        HeaderView(dateString: "Fri, 16 May 2025", onSettingsTapped: {})
        Spacer()
    }
}
