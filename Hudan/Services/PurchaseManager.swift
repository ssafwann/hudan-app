import SwiftUI

final class PurchaseManager: ObservableObject {
    
    // The singleton instance the whole app will share.
    static let shared = PurchaseManager()
    
    // This is the "source of truth". @AppStorage saves it to UserDefaults automatically.
    // The rest of the app will read this value to see if the feature is unlocked.
    @AppStorage("isFeatureUnlocked") var isFeatureUnlocked: Bool = false
    
    // The function our PaywallView will call.
    // Right now, it just flips the boolean. Later, this will trigger the real purchase.
    func purchase() {
        // --- SIMULATED PURCHASE ---
        self.isFeatureUnlocked = true
    }
    
    // The function our PaywallView's "Restore" button will call.
    // Right now, it does nothing. Later, this will check for previous transactions.
    func restorePurchases() {
        // --- SIMULATED RESTORE ---
        print("Restoring purchases...")
        // In a real app, you might flip this to true for testing restores.
        // self.isFeatureUnlocked = true
    }
    
    // A private initializer to ensure only one instance is ever created.
    private init() {}
}
