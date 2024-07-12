//
//  TimerWid.swift
//  TimerWid
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let entry = SimpleEntry(date: .now, configuration: configuration)
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct TimerWidEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Timbbbaaaa:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct Calculator_WidgetEntryView2: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Timbbbaaaa:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct TimerWid: Widget {
    let kind: String = "Calculator_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TimerWidEntryView(entry: entry)
        }
    }
}

// private extension ConfigurationAppIntent {
//    static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//
//    static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
// }

// #Preview(as: .systemSmall) {
//    TimerWid()
// } timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
// }

// extension View {
//    func widgetBackground(_ backgroundView: some View) -> some View {
////        if #available(iOSApplicationExtension 17.0, *) {
//        return containerBackground(for: .widget) {
//            backgroundView
//        }
////        } else {
////            return background(backgroundView)
////        }
//    }
// }

// struct MyWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MyWidgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
// }
