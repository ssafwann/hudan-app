import SwiftUI

// manages background images for the widget
struct WidgetBackgroundManager {
    static let backgroundImages: [String] = [
        "bg1",    // Index 0 - Default background
        "bg2",
        "bg3",
        "bg4",
        "bg5"
    ]
    
    // returns the image for the given index
    static func backgroundImage(at index: Int) -> Image {
        guard index >= 0 && index < backgroundImages.count else {
            return Image(backgroundImages[0]) // returns default if invalid
        }
        return Image(backgroundImages[index])
    }
    
    // returns the current image based on settings.
    static func currentBackgroundImage() -> Image {
        let settings = WidgetSettingsManager.shared
        
        // If using default background, always return the first image
        if settings.backgroundType == .default {
            return backgroundImage(at: 0)
        }
        
        // Otherwise return the selected custom background
        return backgroundImage(at: settings.selectedBackgroundIndex)
    }
} 
