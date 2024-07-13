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
        Logger.sendLog(message: "ProviderのplaceHolder関数着火")
        return SimpleEntry(date: Date(), isOn: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Logger.sendLog(message: "ProviderのgetSnapshot関数着火")
        let entry = SimpleEntry(date: Date(), isOn: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Logger.sendLog(message: "ProviderのgetTimeline関数着火")
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, isOn: true)
            entries.append(entry)
            break
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// タイムラインに利用している型、データのやり取りに使っているっぽい
struct SimpleEntry: TimelineEntry {
    let date: Date
    let isOn: Bool
}

// ウィジェットUIの目に見える部分
struct Timer2WidgetEntryView: View {
    var entry: Provider.Entry

    @State var _isOn: Bool = false // = entry.isOn

    init(entry: Provider.Entry) {
        self.entry = entry
        Logger.sendLog(message: "Timer2WidgetEntryViewのinitが呼ばれた。entryを書き換えている entry", entry, "isOn", _isOn)
    }

    var body: some View {
        VStack {
            Toggle(isOn: $_isOn) {
                if entry.isOn {
                    Text("on")
                } else {
                    Text("off")
                }
            }
            .onAppear {
                self._isOn = entry.isOn
            }
            .onChange(of: entry.isOn) { a, b in
                Logger.sendLog(message: "トグル変更、a", a, "b", b)
            }

//            // リンク これもデザインできるが、さて。
//            Link(destination: URL(string: "mywidget://toggle")!) { // TODO: これは機能していないかと思ったが今は動いていそう、今回は使わない。
//                Text("スイッチを切り替える")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }

//            // ボタン 純粋なインタラクションとして制御されるらしい。このボタンを押されたかどうかというI/Oができるといいんだけど。
//            Button(action: {
//                Logger.sendLog(message: "Buttonw_was_tapped")
//            }) {
//                Text("ボタンを押すTimer2WidgetEntryView")
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
        }
    }
}

// ウィジェットUIの本体の見た目をロードする部分
struct Timer2Widget: Widget {
    let kind: String = "Timer2Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Timer2WidgetEntryView(entry: entry).containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
