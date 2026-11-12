import WidgetKit
import SwiftUI

struct GrokBotEntry: TimelineEntry {
    let date: Date
    let faceHappy: Bool
    let taskStates: [Int]

    var doneCount: Int { taskStates.filter { $0 == 2 }.count }

    static var current: GrokBotEntry {
        GrokBotEntry(
            date: Date(),
            faceHappy: SharedState.faceHappy,
            taskStates: (0..<3).map { SharedState.taskState($0) }
        )
    }
}

struct GrokBotProvider: TimelineProvider {
    func placeholder(in context: Context) -> GrokBotEntry {
        GrokBotEntry(date: Date(), faceHappy: false, taskStates: [0, 0, 0])
    }

    func getSnapshot(in context: Context, completion: @escaping (GrokBotEntry) -> Void) {
        completion(.current)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GrokBotEntry>) -> Void) {
        // State changes come from AppIntents, which call reloadAllTimelines(),
        // so the timeline itself does not need frequent refreshes.
        let timeline = Timeline(entries: [.current], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct GrokBotWidget: Widget {
    let kind: String = "GrokBotWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GrokBotProvider()) { entry in
            GrokBotWidgetView(entry: entry)
        }
        .configurationDisplayName("Grok Bot")
        .description("Tap the face and tasks right on your home screen.")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct GrokBotWidgetBundle: WidgetBundle {
    var body: some Widget {
        GrokBotWidget()
    }
}
