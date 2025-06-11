import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = WidgetSettingsManager.shared
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    @ObservedObject private var customBgManager = CustomBgManager.shared
    @State private var showInfoView = false
    
    // State to manage paywall presentation
    @State private var showPaywall = false
    @State private var showCustomBgView = false
    
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
                        Text("Hadith Text")
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
                                        .foregroundColor(settings.textDisplay == option ? .white : Color("HadithText"))
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
                        
                        HStack(spacing: 12) {
                            ForEach(WidgetBackgroundType.allCases, id: \.self) { option in
                                Button(action: {
                                    settings.backgroundType = option
                                }) {
                                    Text(option.rawValue.capitalized)
                                        .font(.custom("HelveticaNeue-Medium", size: 12))
                                        .kerning(-0.5)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(settings.backgroundType == option ? Color("SecondaryGreen") : Color("White"))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .stroke(settings.backgroundType == option ? Color.clear : Color("BtnBorder"), lineWidth: 2)
                                                )
                                        )
                                        .foregroundColor(settings.backgroundType == option ? .white : Color("HadithText"))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        
                        // Show image selection only for .default background type
                        if settings.backgroundType == .default {
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
                        } else if settings.backgroundType == .custom {
                            if purchaseManager.isFeatureUnlocked {
                                // If the feature is unlocked, show the new row with the integrated Add button.
                                CustomBgRow(
                                    onAdd: { showCustomBgView = true }
                                )
                            } else {
                                // If the feature is locked, show the old unlock button.
                                Button(action: { showPaywall = true }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color("PrimaryGreen"))
                                        Text("Unlock custom features")
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
        .presentationCornerRadius(24)
        .presentationDragIndicator(.visible)
        .fullScreenCover(isPresented: $showInfoView) {
            InfoView()
        }
        .fullScreenCover(isPresented: $showPaywall) {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                PaywallView(
                    onDismiss: { showPaywall = false },
                    onPurchaseSuccess: {
                        purchaseManager.purchase()
                        showPaywall = false
                    }
                )
            }
            .presentationBackground(.clear)
        }
        .fullScreenCover(isPresented: $showCustomBgView) {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                CustomBgView(isPresented: $showCustomBgView)
            }
            .presentationBackground(.clear)
        }
    }
}

#Preview {
    SettingsView()
}

