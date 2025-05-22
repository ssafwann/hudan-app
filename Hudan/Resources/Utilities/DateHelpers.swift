import Foundation

enum DateHelpers {
    // Get the current date in UTC
    static func getCurrentUTCDate() -> Date {
        let now = Date()
        let utcCalendar = Calendar.current
        var utcComponents = utcCalendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: now)
        
        // Create a new date with UTC components
        return utcCalendar.date(from: utcComponents) ?? now
    }
    
    // Format date for display in header (e.g., "Fri, 16 May 2025")
    static func formatDateForHeader(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        return formatter.string(from: date)
    }
}

