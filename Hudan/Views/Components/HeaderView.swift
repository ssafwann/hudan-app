import SwiftUI

struct HeaderView: View {
    var dateString: String
    var onSettingsTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            // Left column - date, title, and tagline
            VStack(alignment: .leading, spacing: 0) {
                // Date with calendar icon
                HStack(spacing: 6) {
                    Image("CalendarIcon")
                        .resizable()
                          .frame(width: 18, height: 18)
                    
                    Text(dateString)
                        .font(.custom("HelveticaNeue-Regular", size: 14))
                        .foregroundColor(Color("AppLightText"))
                        .kerning(-0.25)
                }
                .padding(.bottom, 8)

                // Title
                Text("Today's Hadith")
                    .font(.custom("HelveticaNeue-Medium", size: 32))
                    .foregroundColor(Color("PrimaryGreen"))
                    .padding(.bottom, 12)
                    .accessibilityAddTraits(.isHeader)
                
                // Tagline
                Text("Gain wisdom from the words and actions of our Prophet Muhammad ﷺ")
                    .font(.custom("HelveticaNeue", size: 16))
                    .foregroundColor(Color("AppDarkText"))
                    .lineLimit(2)
                    .lineSpacing(3)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            
            Spacer()
            
            // Right column - settings button (aligned to top)
            Button(action: onSettingsTapped) {
                Image("SettingsIcon")
                    .resizable()
                      .frame(width: 18, height: 18)
                    .foregroundColor(Color("AppDarkText"))
                    .frame(width: 40, height: 40)
                    .background(Color("UBtn"))
                    .cornerRadius(10)
            }
            .accessibilityLabel("Settings")
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        HeaderView(dateString: "Fri, 16 May 2025", onSettingsTapped: {})
        Spacer()
    }
}
