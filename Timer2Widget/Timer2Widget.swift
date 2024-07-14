//
//  Timer2Widget.swift
//  Timer2Widget
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TimerEntry {
        Logger.sendLog(message: "ProviderのplaceHolder関数着火")
        return TimerEntry(date: Date(), isOn: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> ()) {
        Logger.sendLog(message: "ProviderのgetSnapshot関数着火")
        let entry = TimerEntry(date: Date(), isOn: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Logger.sendLog(message: "AppからWidgetにデータが届いた。ProviderのgetTimeline関数着火")
        guard let isOn = geFromAppGroupUserDefaults(forKey: "IsOn") else { return } // ファイルがヒットしなかったら何もしない
        var entries: [TimerEntry] = []

        let entry = TimerEntry(date: .now, isOn: isOn)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    // TODO: この関数をstaticにしてproject全体から触れるようにする
    func geFromAppGroupUserDefaults(forKey: String) -> Bool? {
        // TODO: AppGroupのファイルアクセス共有のための定数にする
        guard let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp") else { return nil }
        let value = defaults.bool(forKey: forKey)

        return value
    }
}

// タイムラインに利用している型、AppからOSを通じて、widgetの表示を更新する際にwidget側がpullする。
// 特にAppやOSによって変質することはなく、widgetがread時に自分で整形する。
struct TimerEntry: TimelineEntry {
    let date: Date
    let isOn: Bool
}

// ウィジェットUIの目に見える部分
struct Timer2WidgetEntryView: View {
    var entry: Provider.Entry

    @State var _isOn: Bool = false

    init(entry: Provider.Entry) {
        // widgetがUI表示するentryデータを更新する
        self.entry = entry
    }

    var body: some View {
        VStack {
            // リンクとして機能するtoggle
            Link(destination: URL(string: "mywidget://toggle?ison=" + String(entry.isOn))!) {
                Toggle(isOn: $_isOn) {
                    if entry.isOn {
                        Text("ON")
                            .foregroundStyle(.white)
                    } else {
                        Text("OFF")
                            .foregroundStyle(.white)
                    }
                }
                .toggleStyle(.automatic) // ボタン以外はmacOS SonomaのwidgetではUIが表示されず、動かない。まあ切り替えられればそれでいいので文句はない
                .onAppear {
                    self._isOn = entry.isOn // 外部から渡ってくる初期値を反映させる
                }
            }
        }
    }
}

// ウィジェットUIの本体の見た目をロードする部分
struct Timer2Widget: Widget {
    // この名称は外部へのIDになっており、正しくないものにするとdownstreamが滞る。
    let kind: String = "Timer2Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Timer2WidgetEntryView(entry: entry).containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
