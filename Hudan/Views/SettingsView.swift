//
//  SettingsView.swift
//  Hudan
//
//  Created by Malik Safwan on 21/5/2025.
//

import SwiftUI

struct SettingsView: View {
    // Use @StateObject for ObservableObject singletons to ensure the view subscribes
    // to its changes and manages its lifecycle appropriately within the view.
    @StateObject private var settings = WidgetSettingsManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header for the Sheet
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
                    // Verse Text Options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Verse Text")
                            .font(.system(size: 17))
                        
                        HStack(spacing: 8) {
                            ForEach(WidgetTextDisplay.allCases, id: \.self) { option in
                                Button(action: {
                                    print("[SettingsView Button Action] Tapped. Current 'option' in this button's scope is: \(option.rawValue)")
                                    settings.textDisplay = option
                                    print("[SettingsView Button Action] settings.textDisplay was set to \(option.rawValue). Getter now returns: \(settings.textDisplay.rawValue)")
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
                    .padding(.vertical, 8) // Padding for content within the list row
                    
                    // Background Options
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
                                            Image("bg\(index + 1)") // Assuming these images are in your asset catalog
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
                    .padding(.vertical, 8) // Padding for content within the list row
                    
                } header: {
                    Text("WIDGET")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.medium)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)) // Adjust row insets
                .listRowBackground(Color.clear) // Ensure section background is transparent
            }
            .listStyle(.insetGrouped)
            .environment(\.defaultMinListHeaderHeight, 30) // Adjust header height
        }
        .onAppear {
            print("SettingsView appeared. Initial settings:")
            print("Text Display: \(settings.textDisplay.rawValue)")
            print("Background Type: \(settings.backgroundType.rawValue)")
        }
        .presentationDetents([.fraction(0.4)])
    }
}

#Preview {
    SettingsView()
}

