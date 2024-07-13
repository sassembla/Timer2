//
//  Timer2Widget.swift
//  Timer2Widget
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        Logger.sendLog(message: "Provider placeholder here")
        return SimpleEntry(date: Date(), isOn: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), isOn: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, isOn: false)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isOn: Bool
}

struct Timer2WidgetEntryView: View {
    var entry: Provider.Entry
//    @State private var isOn: Bool = false
    @Environment(\.widgetFamily) var family

    init(entry: Provider.Entry) {
        self.entry = entry
        Logger.sendLog(message: "Timer2WidgetEntryViewのinit")
//        self.family = family
    }

    @State private var showAlert = false

    var body: some View {
        VStack {
            if entry.isOn {
                Text("スイッチはオンです")
            } else {
                Text("スイッチはオフです")
            }

            Link(destination: URL(string: "mywidget://toggle")!) {
                Text("スイッチを切り替える")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                showAlert = true
                Logger.sendLog(message: "Buttonw_was_tapped")
            }) {
                Text("ボタンを押すTimer2WidgetEntryView")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct Timer2Widget: Widget {
    let kind: String = "Timer2Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Timer2WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
