import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = WidgetSettingsManager.shared
    @State private var showInfoView = false
    
    var body: some View {
        VStack(spacing: 0,) {
            // header
            HStack {
                Image("BlackSettingsIcon")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("Settings")
                    .font(.custom("HelveticaNeue-Medium", size: 18))
                    .foregroundColor(Color("HadithText"))
                Spacer()
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        showInfoView = true
                    }
                }) {
                    Image("InfoIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.horizontal)
            .padding(.top, 35)
            .padding(.bottom, 20)
            .background(Color("White"))
            
            Divider()
            
            List {
                Section {
                    // verse text option
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Verse Text")
                            .font(.custom("HelveticaNeue-Medium", size: 12))
                            .foregroundStyle(Color("DarkText"))
                            .kerning(-0.25)


                        HStack(spacing: 12) {
                            ForEach(WidgetTextDisplay.allCases, id: \.self) { option in
                                Button(action: {
                                    settings.textDisplay = option
                                }) {
                                    Text(option.rawValue.capitalized)
                                        .font(.custom("HelveticaNeue-Medium", size: 12))
                                        .kerning(-0.5)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(settings.textDisplay == option ? Color("SecondaryGreen") : Color("White"))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .stroke(settings.textDisplay == option ? Color.clear : Color("BtnBorder"), lineWidth: 2)
                                                )
                                        )
                                        .foregroundColor(settings.textDisplay == option ? .white : .primary)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    .padding(.vertical, 22)
                    
                    // background options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Background")
                            .font(.custom("HelveticaNeue-Medium", size: 12))
                            .foregroundStyle(Color("DarkText"))
                            .kerning(-0.25)
                        
                        /* // Temporarily commented out the background type selection buttons
                        HStack(spacing: 8) {
                            ForEach(WidgetBackgroundType.allCases, id: \.self) { option in
                                Button(action: {
                                    settings.backgroundType = option
                                }) {
                                    Text(option.rawValue.capitalized)
                                        .font(.system(size: 17))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(settings.backgroundType == option ? Color("SecondaryGreen") : Color(.systemGray6))
                                        )
                                        .foregroundColor(settings.backgroundType == option ? .white : .primary)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        */
                        
                        // if settings.backgroundType == .default { // Show image selection when .default is selected
                        // Since .default is now the only background mode, always show the image selection.
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<WidgetBackgroundManager.backgroundImages.count, id: \.self) { index in
                                    Button(action: {
                                        settings.selectedBackgroundIndex = index
                                    }) {
                                        Image("bg\(index + 1)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 64, height: 64)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(
                                                ZStack {
                                                    // Universal border for all states
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color("LightText"), lineWidth: 1)

                                                    if settings.selectedBackgroundIndex == index {
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color.black.opacity(0.3)) // Slight dim for better checkmark visibility
                                                        Image("TickIcon")
                                                            .resizable()
                                                            .frame(width: 18, height: 18)          
                                                            .foregroundColor(.white)
                                                    } 
                                                    // Removed 'else' branch for unselected border as it's now universal
                                                }
                                            )
                                    }
                                }
                            }
                        }
                    }
                    // gap between 2 sections
                    .padding(.vertical, 12)
                } header: {
                    Text("WIDGET")
                        .font(.custom("HelveticaNeue-Medium", size: 14))
                        .foregroundColor(Color("LightText"))
                        .kerning(0.25)
                        .padding(.top, 20)

                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color("White"))
                .listRowSeparator(.hidden)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .environment(\.defaultMinListHeaderHeight, 30)
        }
        .background(Color("White").edgesIgnoringSafeArea(.all))
        // sheet height
        .presentationDetents([.fraction(0.45)])
        .presentationCornerRadius(24)
        .presentationDragIndicator(.visible)
        .fullScreenCover(isPresented: $showInfoView) {
            InfoView()
        }
    }
}

#Preview {
    SettingsView()
}

