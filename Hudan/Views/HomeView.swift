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
        ScrollView {
            VStack(spacing: 0) {
                HeaderView(
                    dateString: DateHelpers.formatDateForHeader(),
                    onSettingsTapped: { showSettings = true }
                )
                
                if let currentHadith = model.currentHadith {
                    HadithCard(
                        hadith: currentHadith,
                        onCopyTapped: {
                            model.copyToClipboard(text: currentHadith.english)
                        }
                    )
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                
                Spacer(minLength: 0)
            }
            .background(Color("MainBg"))

        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showSettings) {
            Text("Settings")
        }
        .padding(.top, 24) // adjust as needed (44–60 works well for most devices)
        .background(Color("MainBg"))
    }
}

#Preview {
    HomeView()
}
