import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> HadithTimelineEntry {
        HadithTimelineEntry.placeholder()
    }

    func getSnapshot(in context: Context, completion: @escaping (HadithTimelineEntry) -> ()) {
        let entry = HadithTimelineEntry.snapshot()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HadithTimelineEntry>) -> ()) {
        // 1. Access WidgetSettingsManager for current settings
        let settings = WidgetSettingsManager.shared

        // 2. Load Hadith data from JSON
        var allHadiths: [Hadith] = []
        // Ensure we use the widget's bundle to find the JSON.
        if let url = Bundle.main.url(forResource: "hadiths", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode([Hadith].self, from: data) {
                allHadiths = jsonData
            }
        }

        // 3. Determine the Hadith to display
        let currentHadithToDisplay: Hadith?
        
        currentHadithToDisplay = allHadiths.first
        

        // 4. Create the timeline entry
        let entryDate = Date()
        let entry: HadithTimelineEntry

        if let hadith = currentHadithToDisplay {
            entry = HadithTimelineEntry(
                date: entryDate,
                hadithID: hadith.id,
                arabicText: hadith.arabic,
                summaryText: hadith.summary, 
                referenceText: hadith.ref,
                textDisplayMode: settings.textDisplay,
                backgroundType: settings.backgroundType,
                selectedBackgroundIndex: settings.selectedBackgroundIndex
            )
        } else {
            // Fallback to placeholder if no Hadith could be loaded
            entry = HadithTimelineEntry.placeholder()
        }

        // 5. Create the timeline.
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: entryDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct HadithTimelineEntry: TimelineEntry {
    let date: Date
    
    let hadithID: Int?
    let arabicText: String?
    let summaryText: String?
    let referenceText: String?
    
    // Settings from WidgetSettingsManager
    let textDisplayMode: WidgetTextDisplay
    let backgroundType: WidgetBackgroundType
    let selectedBackgroundIndex: Int
    
    static func placeholder() -> HadithTimelineEntry {
        HadithTimelineEntry(
            date: Date(),
            hadithID: 1,
            arabicText: "الْأَعْمَالُ بِالنِّيَّاتِ", // Sample Arabic
            summaryText: "When one of you asks from his Lord, let him ask for even more. Verily, he is asking from his lord Almighty.", // Sample English
            referenceText: "SAHIH IBN HIBBAN 889",
            textDisplayMode: .english, // Default display mode
            backgroundType: .default, // Default background type
            selectedBackgroundIndex: 2 // Default background index
        )
    }
    
    static func snapshot() -> HadithTimelineEntry {
        placeholder()
    }
}

struct HudanWidgetEntryView : View {
    var entry: HadithTimelineEntry
    @Environment(\.widgetFamily) var widgetFamily // For dynamic styling
    
    // Font names (as per your previous spec)
    private let arabicFontName = "KFGQPCHAFSUthmanicScript-Regula"
    private let summaryFontName = "Georgia"
    private let referenceFontName = "HelveticaNeue"
    
    // Computed styling properties (adjust these as needed after testing)
    private var summaryFontSize: CGFloat { widgetFamily == .systemLarge ? 19 : 16 }
    private var referenceFontSize: CGFloat { widgetFamily == .systemLarge ? 13 : 11 }
    private var arabicFontSize: CGFloat { widgetFamily == .systemLarge ? 21 : 17 }
    
    private var summaryLineLimit: Int { widgetFamily == .systemLarge ? 6 : 4 }
    private var arabicLineLimit: Int { widgetFamily == .systemLarge ? 5 : 3 }
    private var referenceLineLimit: Int { 1 }
    private var VstackSpacing: CGFloat { widgetFamily == .systemLarge ? 10 : 6}
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                if entry.backgroundType == .default {
                    Image("bg\(entry.selectedBackgroundIndex + 3)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    Color(UIColor.systemBackground)
                }
                
                Color.black.opacity(0.4)
                
                VStack(alignment: .leading, spacing: VstackSpacing) {
                    // Arabic
                    if entry.textDisplayMode == .arabic || entry.textDisplayMode == .both {
                        if let arabicText = entry.arabicText, !arabicText.isEmpty {
                            Text(arabicText)
                                .font(.custom(arabicFontName, size: arabicFontSize))
                                .multilineTextAlignment(.trailing)
                                .environment(\.layoutDirection, .rightToLeft)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .lineLimit(arabicLineLimit)
                        }
                    }
                    
                    // English
                    if entry.textDisplayMode == .english || entry.textDisplayMode == .both {
                        if let summaryText = entry.summaryText, !summaryText.isEmpty {
                            Text(summaryText)
                                .font(.custom(summaryFontName, size: summaryFontSize))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(summaryLineLimit)
                        }
                    }
                    
                    // Reference
                    if let referenceText = entry.referenceText, !referenceText.isEmpty {
                        Text(referenceText.uppercased())
                            .font(.custom(referenceFontName, size: referenceFontSize))
                            .tracking(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(referenceLineLimit)
                            .opacity(0.8)
                    }
                }
                .padding(.top, 40) // This will now actually work
                .padding(.horizontal, widgetFamily == .systemLarge ? 24 : 24)
                .padding(.bottom, 16)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .foregroundColor(.white)
            }
        }
    }
}

struct HudanWidget: Widget {
    let kind: String = "HudanWidget"
    

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HudanWidgetEntryView(entry: entry)
                    .containerBackground(Color.clear, for: .widget)
            } else {
                HudanWidgetEntryView(entry: entry)
                    .background(Color.clear)
            }
        }
        .configurationDisplayName("Daily Hadith")
        .description("Displays a daily hadith from Hudan.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

    

#Preview(as: .systemMedium) {
    HudanWidget()
} timeline: {
    HadithTimelineEntry.placeholder()
    HadithTimelineEntry(date: .now, hadithID: 2, arabicText: "الى تشكيل والفلبين هو. أدنى الشرقية ما بين. وبدون أواخر قُدُماً دار هو. بـ دنو صفحة الشهير مشاركة, يتبقّ الحيلولة الا ثم. الإنزال ", summaryText: "When one of you asks from his Lord, let him ask for even more. Verily, he is asking from his lord Almighty.", referenceText: "Reference 2", textDisplayMode: .both, backgroundType: .default, selectedBackgroundIndex: 1)
}

#Preview(as: .systemLarge) {
    HudanWidget()
} timeline: {
    HadithTimelineEntry.placeholder()
}
