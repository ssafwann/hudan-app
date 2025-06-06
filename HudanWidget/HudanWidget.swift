import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HadithTimelineEntry {
        .placeholder()
    }

    func getSnapshot(in context: Context, completion: @escaping (HadithTimelineEntry) -> ()) {
        let entry = getDailyHadithEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HadithTimelineEntry>) -> ()) {
        let entry = getDailyHadithEntry()
        
        // --- Smart Timeline Refresh ---
        let calendar = Calendar(identifier: .gregorian)
        guard let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else {
            // Fallback to hourly refresh if date calculation fails
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
            return
        }

        let timeline = Timeline(entries: [entry], policy: .after(startOfTomorrow))
        completion(timeline)
    }
    
    // This is the core logic for selecting the daily hadith. It's now self-contained and correct.
    private func getDailyHadithEntry() -> HadithTimelineEntry {
        // 1. Load Hadith data from JSON
        guard let url = Bundle.main.url(forResource: "hadiths", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              var hadiths = try? JSONDecoder().decode([Hadith].self, from: data),
              !hadiths.isEmpty else {
            return .placeholder() // Return placeholder if loading fails
        }
        
        // 2. Sort hadiths to ensure consistent order
        hadiths.sort { $0.id < $1.id }
        
        // 3. Deterministically select hadith based on the UTC day of the year
        let calendar = Calendar(identifier: .gregorian)
        let currentUTCDate = getCurrentUTCDate() // Use UTC date
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentUTCDate) ?? 1
        let selectedIndex = (dayOfYear - 1) % hadiths.count
        let selectedHadith = hadiths[selectedIndex]
        
        // 4. Create the entry with default settings
        return HadithTimelineEntry(date: Date(), hadith: selectedHadith)
    }
    
    // Helper function to get the current date in UTC, ensuring sync with the main app's logic.
    private func getCurrentUTCDate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components) ?? Date()
    }
}

// MARK: - Timeline Entry
struct HadithTimelineEntry: TimelineEntry {
    let date: Date
    let hadith: Hadith
    
    // For now, settings are hardcoded. Later, this can be passed from the app via App Groups.
    let textDisplayMode: WidgetTextDisplay = .both
    let backgroundType: WidgetBackgroundType = .default
    let selectedBackgroundIndex: Int = 1
    
    static func placeholder() -> HadithTimelineEntry {
        HadithTimelineEntry(
            date: Date(),
            hadith: Hadith(
                id: 1,
                narrator: "Umar bin Al-Khattab",
                arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
                english: "The reward of deeds depends upon the intentions...",
                summary: "The reward of deeds depends upon the intentions and every person will get the reward according to what he has intended.",
                ref: "Sahih al-Bukhari 1",
                inbook_ref: "Book 1, Hadith 1",
                grade: "Sahih"
            )
        )
    }
}

// MARK: - Widget View
struct HudanWidgetEntryView : View {
    var entry: HadithTimelineEntry
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                WidgetBackgroundView(
                    type: entry.backgroundType,
                    index: entry.selectedBackgroundIndex
                )
                .frame(width: geo.size.width, height: geo.size.height)
                
                WidgetContentView(entry: entry)
                    .padding(.top, 40)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 16)
            }
        }
    }
}

// MARK: - Subviews
private struct WidgetBackgroundView: View {
    let type: WidgetBackgroundType
    let index: Int
    
    var body: some View {
        ZStack {
            if type == .default {
                Image("bg\(index + 3)")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.95)
            } else {
                Color(UIColor.systemBackground)
            }
            Color.black.opacity(0.3) // Readability overlay
        }
    }
}

private struct WidgetContentView: View {
    let entry: HadithTimelineEntry
    @Environment(\.widgetFamily) private var widgetFamily

    private var isLargeFamily: Bool { widgetFamily == .systemLarge }
    
    private var summaryFontSize: CGFloat { isLargeFamily ? 18 : 14 }
    private var referenceFontSize: CGFloat {
        switch entry.textDisplayMode {
        case .both: return isLargeFamily ? 11 : 9
        case .arabic, .english: return isLargeFamily ? 13 : 11
        }
    }
    private var arabicFontSize: CGFloat {
        switch entry.textDisplayMode {
        case .both: return isLargeFamily ? 20 : 16
        case .arabic: return isLargeFamily ? 22 : 18
        case .english: return 0
        }
    }
    
    private var summaryLineLimit: Int {
        switch entry.textDisplayMode {
        case .english: return isLargeFamily ? 6 : 3
        case .arabic: return 0
        case .both: return isLargeFamily ? 3 : 1
        }
    }
    private var arabicLineLimit: Int {
        switch entry.textDisplayMode {
        case .arabic: return isLargeFamily ? 6 : 2
        case .english: return 0
        case .both: return isLargeFamily ? 3 : 1
        }
    }
    
    private var vStackSpacing: CGFloat {
        if entry.textDisplayMode == .arabic {
            return 10
        } else {
            return isLargeFamily ? 10 : 6
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: vStackSpacing) {
            // Arabic Text
            if entry.textDisplayMode == .arabic || entry.textDisplayMode == .both {
                Text(entry.hadith.arabic)
                    .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: arabicFontSize))
                    .foregroundColor(.white)
                    .lineSpacing(isLargeFamily ? 14 : 12)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .lineLimit(arabicLineLimit)
                    .padding(.bottom, entry.textDisplayMode == .both ? 6 : 0)
            }

            // English/Summary Text
            if entry.textDisplayMode == .english || entry.textDisplayMode == .both {
                Text(entry.hadith.summary)
                    .font(.custom("Georgia", size: summaryFontSize))
                    .foregroundColor(.white)
                    .lineSpacing(isLargeFamily ? 8 : 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(summaryLineLimit)
            }
            
            // Reference Text
            Text(entry.hadith.ref.uppercased())
                .font(.custom("HelveticaNeue", size: referenceFontSize))
                .foregroundColor(Color("Reference"))
                .frame(maxWidth: .infinity, alignment: entry.textDisplayMode == .arabic ? .trailing : .leading)
                .lineLimit(1)
            
            // This Spacer pushes all the content above it to the top.
            Spacer(minLength: 0)
        }
        .environment(\.layoutDirection, entry.textDisplayMode == .arabic ? .rightToLeft : .leftToRight)
    }
}


// MARK: - Widget Configuration
struct HudanWidget: Widget {
    let kind: String = "HudanWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HudanWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Daily Hadith")
        .description("Displays a daily hadith from Hudan.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

// MARK: - Previews
#Preview(as: .systemMedium) {
    HudanWidget()
} timeline: {
    HadithTimelineEntry.placeholder()
}

#Preview(as: .systemLarge) {
    HudanWidget()
} timeline: {
    HadithTimelineEntry.placeholder()
}
