import Foundation
import SwiftUI
import Combine
import WidgetKit

enum WidgetTextDisplay: String, CaseIterable {
    case english
    case arabic
    case both
}

enum WidgetBackgroundType: String, CaseIterable {
    case `default`
    case custom // Temporarily commented out to only allow default background type
}

private enum WidgetSettingsKey {
    static let textDisplay = "widget.textDisplay"
    static let backgroundType = "widget.backgroundType"
    static let selectedBackgroundIndex = "widget.selectedBackgroundIndex"
}

final class WidgetSettingsManager: ObservableObject {
    // singleton: allows all parts of app to work with the same settings data.
    static let shared = WidgetSettingsManager()

    // used for persistance storage
    private let defaults: UserDefaults
    
    var textDisplay: WidgetTextDisplay {
        // reads the settings from userDefaults
        get {
            guard let rawValue = defaults.string(forKey: WidgetSettingsKey.textDisplay),
                  let value = WidgetTextDisplay(rawValue: rawValue) else {
                return .english // default value
            }
            return value
        }
        // called when a new value is assigned (e.g.g settings.textDisplay = ..)
        set {
            // this manually notifies that a prop of this obj is about to change. (doens't actually change it)
            objectWillChange.send()
            defaults.setValue(newValue.rawValue, forKey: WidgetSettingsKey.textDisplay)
            updateWidget()
        }
    }
    
    var backgroundType: WidgetBackgroundType {
        get {
            guard let rawValue = defaults.string(forKey: WidgetSettingsKey.backgroundType),
                  let value = WidgetBackgroundType(rawValue: rawValue) else {
                return .default
            }
            return value
        }
        set {
            objectWillChange.send()
            defaults.setValue(newValue.rawValue, forKey: WidgetSettingsKey.backgroundType)
            updateWidget()
        }
    }
    
    // current selected bg index
    var selectedBackgroundIndex: Int {
        get {
            defaults.integer(forKey: WidgetSettingsKey.selectedBackgroundIndex)
        }
        set {
            objectWillChange.send()
            defaults.setValue(newValue, forKey: WidgetSettingsKey.selectedBackgroundIndex)
            updateWidget()
        }
    }
        
    private init() {
        // Get shared UserDefaults for the app group
        guard let defaults = UserDefaults(suiteName: Constants.widgetSettingsSuiteName) else {
            fatalError("Failed to initialize UserDefaults with suite name: \(Constants.widgetSettingsSuiteName)")
        }
        self.defaults = defaults
        // Register default values if not already set
        registerDefaults()
    }
        
    private func registerDefaults() {
        let defaultsToRegister: [String: Any] = [
            WidgetSettingsKey.textDisplay: WidgetTextDisplay.english.rawValue,
            WidgetSettingsKey.backgroundType: WidgetBackgroundType.default.rawValue, // Ensure default is .default
            WidgetSettingsKey.selectedBackgroundIndex: 0
        ]
        
        self.defaults.register(defaults: defaultsToRegister)
    }
    
    private func updateWidget() {
        #if os(iOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
        
    func resetToDefaults() {
        objectWillChange.send()
        textDisplay = .english
        backgroundType = .default
        selectedBackgroundIndex = 0
    }
}
