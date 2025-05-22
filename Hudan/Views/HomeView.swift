// main hadith display

import SwiftUI

// AlQuranIndoPakbyQuranWBW
// EBGaramond-Regular
// EBGaramondRoman-SemiBold
// KFGQPCHAFSUthmanicScript-Regula
// Georgia
// HelveticaNeue

struct HomeView: View {
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
            
            Spacer()
        }
        .background(Color(Color("MainBg"))) // Set the background color here
        .sheet(isPresented: $showSettings) {
            // Settings view will go here
            Text("Settings")
        }
    }
}

#Preview {
    HomeView()
}
