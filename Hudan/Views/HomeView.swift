import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let model: HadithViewModel
    // tracker whether the settings should be shown
    @State private var showSettings = false
    
    init(model: HadithViewModel = HadithViewModel()) {
        self.model = model
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                dateString: DateHelpers.formatDateForHeader(),
                onSettingsTapped: { showSettings = true }
            )
            
            if let currentHadith = model.currentHadith {
                HadithCard(hadith: currentHadith)
                    .padding(.vertical)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .background(Color("MainBg"))
        .sheet(isPresented: $showSettings) {
            if horizontalSizeClass == .compact {
                SettingsView()
                    .presentationDetents([.fraction(0.45)])
            } else {
                SettingsView()
            }
        }
    }
}

#Preview {
    HomeView()
}
