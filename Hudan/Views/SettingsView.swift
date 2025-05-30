import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = WidgetSettingsManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // header
            HStack {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                Text("Settings")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
            }
            .padding()
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.top))
            
            List {
                Section {
                    // verse text option
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Verse Text")
                            .font(.system(size: 17))
                        
                        HStack(spacing: 8) {
                            ForEach(WidgetTextDisplay.allCases, id: \.self) { option in
                                Button(action: {
                                    settings.textDisplay = option
                                }) {
                                    Text(option.rawValue.capitalized)
                                        .font(.system(size: 17))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(settings.textDisplay == option ? Color("SecondaryGreen") : Color(.systemGray6))
                                        )
                                        .foregroundColor(settings.textDisplay == option ? .white : .primary)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // background options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Background")
                            .font(.system(size: 17))
                        
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
                        
                        if settings.backgroundType == .custom {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
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
                                                        if settings.selectedBackgroundIndex == index {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color.black.opacity(0.3)) // Slight dim for better checkmark visibility
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 24, weight: .bold))
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 8)
                    
                } header: {
                    Text("WIDGET")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.medium)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowBackground(Color.clear)
            }
            .listStyle(.insetGrouped)
            .environment(\.defaultMinListHeaderHeight, 30)
        }
        // sheet height
        .presentationDetents([.fraction(0.4)])
    }
}

#Preview {
    SettingsView()
}

