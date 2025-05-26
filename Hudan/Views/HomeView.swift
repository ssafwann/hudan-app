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
            
            ScrollView {
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color("MainBg"))
        .sheet(isPresented: $showSettings) {
            Text("Settings")
        }
    }
}

#Preview {
    HomeView()
}
