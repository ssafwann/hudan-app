import Foundation
import SwiftUI
import Combine // Needed for ObservableObject and @Published
import WidgetKit


// text options
enum WidgetTextDisplay: String, CaseIterable {
    case english
    case arabic
    case both
}

// background options
enum WidgetBackgroundType: String, CaseIterable {
    case `default`
    case custom
}

// MARK: - Widget Settings Keys
private enum WidgetSettingsKey {
    static let textDisplay = "widget.textDisplay"
    static let backgroundType = "widget.backgroundType"
    static let selectedBackgroundIndex = "widget.selectedBackgroundIndex"
}

// MARK: - Widget Settings Manager
// N.B. Changed from @Observable to ObservableObject for broader iOS compatibility
// and to work with @StateObject / @ObservedObject.
final class WidgetSettingsManager: ObservableObject {
    static let shared = WidgetSettingsManager()
    
    private let defaults: UserDefaults
    
    // N.B. objectWillChange.send() is called manually in setters because computed properties
    // cannot directly use @Published in the same way stored properties do.
    // Alternatively, make these stored properties and update them from UserDefaults if that fits better.
    
    // curent text display settings
    var textDisplay: WidgetTextDisplay {
        get {
            guard let rawValue = defaults.string(forKey: WidgetSettingsKey.textDisplay),
                  let value = WidgetTextDisplay(rawValue: rawValue) else {
                return .english // Default value
            }
            return value
        }
        set {
            objectWillChange.send() // Manually notify subscribers before the change
            defaults.setValue(newValue.rawValue, forKey: WidgetSettingsKey.textDisplay)
            updateWidget()
        }
    }
    
    // current bg settings
    var backgroundType: WidgetBackgroundType {
        get {
            guard let rawValue = defaults.string(forKey: WidgetSettingsKey.backgroundType),
                  let value = WidgetBackgroundType(rawValue: rawValue) else {
                return .default // Default value
            }
            return value
        }
        set {
            objectWillChange.send()
            defaults.setValue(newValue.rawValue, forKey: WidgetSettingsKey.backgroundType)
            updateWidget()
        }
    }
    
    // current select bg index
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
    
    // MARK: - Initialization
    
    private init() {
        // Get shared UserDefaults for the app group
        guard let defaults = UserDefaults(suiteName: Constants.widgetSettingsSuiteName) else {
            fatalError("Failed to initialize UserDefaults with suite name: \(Constants.widgetSettingsSuiteName)")
        }
        self.defaults = defaults
        
        // Register default values if not already set
        registerDefaults()
    }
    
    // MARK: - Private Methods
    
    private func registerDefaults() {
        let defaultsToRegister: [String: Any] = [
            WidgetSettingsKey.textDisplay: WidgetTextDisplay.english.rawValue,
            WidgetSettingsKey.backgroundType: WidgetBackgroundType.default.rawValue,
            WidgetSettingsKey.selectedBackgroundIndex: 0
        ]
        
        self.defaults.register(defaults: defaultsToRegister)
    }
    
    private func updateWidget() {
        #if os(iOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
    // MARK: - Public Methods
    
    func resetToDefaults() {
        // Manually call objectWillChange.send() for each property being reset
        objectWillChange.send()
        textDisplay = .english       // This will call its own objectWillChange.send()
        objectWillChange.send()
        backgroundType = .default    // This will call its own objectWillChange.send()
        objectWillChange.send()
        selectedBackgroundIndex = 0  // This will call its own objectWillChange.send()
    }
}
