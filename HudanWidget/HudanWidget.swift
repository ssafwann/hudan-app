//
//  HudanWidget.swift
//  HudanWidget
//
//  Created by Malik Safwan on 20/5/2025.
//

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
        
        // --- How to get the "current" Hadith for the widget --- 
        // Option A (Placeholder): Use the first Hadith from the JSON bundled with the widget.
        // This is what we'll use for now until App Group sharing is implemented.
        currentHadithToDisplay = allHadiths.first
        
        // Option B (With App Group - Future): 
        // Your app would save the ID of its `currentHadith` (from HadithViewModel)
        // to the shared UserDefaults via WidgetSettingsManager.
        /*
        if let currentHadithIDFromAppSettings = settings.currentHadithID { // Assuming you add currentHadithID to WidgetSettingsManager
            currentHadithToDisplay = allHadiths.first(where: { $0.id == currentHadithIDFromAppSettings })
        } else {
            currentHadithToDisplay = allHadiths.first // Fallback if ID not found
        }
        */

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

// Replace SimpleEntry with HadithTimelineEntry
struct HadithTimelineEntry: TimelineEntry {
    let date: Date // Required by TimelineEntry
    
    // Data for the Hadith
    let hadithID: Int? 
    let arabicText: String?
    let summaryText: String?
    let referenceText: String?
    
    // Settings from WidgetSettingsManager
    let textDisplayMode: WidgetTextDisplay
    let backgroundType: WidgetBackgroundType
    let selectedBackgroundIndex: Int
    
    // Placeholder/default values
    static func placeholder() -> HadithTimelineEntry {
        HadithTimelineEntry(
            date: Date(),
            hadithID: 1,
            arabicText: "الْأَعْمَالُ بِالنِّيَّاتِ", // Sample Arabic
            summaryText: "Deeds are by intentions.", // Sample English
            referenceText: "Sahih Al-Bukhari 1",
            textDisplayMode: .english, // Default display mode
            backgroundType: .default, // Default background type
            selectedBackgroundIndex: 0 // Default background index
        )
    }
    
    // Snapshot/default entry
    static func snapshot() -> HadithTimelineEntry {
        // For snapshot, try to load actual settings and a sample hadith if possible,
        // otherwise fall back to placeholder. For now, same as placeholder.
        placeholder()
    }
}

struct HudanWidgetEntryView : View {
    var entry: HadithTimelineEntry // Update to use HadithTimelineEntry

    var body: some View {
        // We will replace this VStack with the actual widget UI later
        VStack {
            Text("Hadith Reference:")
            Text(entry.summaryText ?? "N/A")
            Text("Display Mode: \(entry.textDisplayMode.rawValue)")
        }
    }
}

struct HudanWidget: Widget {
    let kind: String = "HudanWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HudanWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HudanWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}


#Preview(as: .systemSmall) {
    HudanWidget()
} timeline: {
    // Update preview timeline to use HadithTimelineEntry
    HadithTimelineEntry.placeholder()
    HadithTimelineEntry(date: .now, hadithID: 2, arabicText: "Sample Arabic 2", summaryText: "Sample Summary 2", referenceText: "Reference 2", textDisplayMode: .both, backgroundType: .default, selectedBackgroundIndex: 1)
}
