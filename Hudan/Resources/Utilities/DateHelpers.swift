import Foundation

enum DateHelpers {
    // Get the current date in UTC
    static func getCurrentUTCDate() -> Date {
        let now = Date()
        let utcCalendar = Calendar.current
        let utcComponents = utcCalendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: now)
        
        // Create a new date with UTC components
        return utcCalendar.date(from: utcComponents) ?? now
    }
    
    // Format date for display in header
    static func formatDateForHeader(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        return formatter.string(from: date)
    }

    func startOfTodayInUTC() -> Date {
        let now = Date()
        let utcCalendar = Calendar(identifier: .gregorian)
        let utcComponents = utcCalendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: now)
        
        // We only care about the date part, so we can ignore the time components for the start of the day.
        let startOfDayComponents = DateComponents(year: utcComponents.year, month: utcComponents.month, day: utcComponents.day)
        
        // Create a new date with UTC components
        return utcCalendar.date(from: startOfDayComponents) ?? now
    }
}

