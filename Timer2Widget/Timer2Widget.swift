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
        guard let isOn = getIsOnFromAppGroup() else { return } // ファイルがヒットしなかったら何もしない
        var entries: [SimpleEntry] = []
        Logger.sendLog(message: "処理を抜けた先で、isOn", isOn)

        let entry = SimpleEntry(date: .now, isOn: isOn)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func getIsOnFromAppGroup() -> Bool? {
        guard let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp") else { return nil }
        return defaults.bool(forKey: "IsOn")
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
            // リンク
            Link(destination: URL(string: "mywidget://toggle?ison=" + String(entry.isOn) + "&other=false")!) {
                Toggle(isOn: $_isOn) {
                    if entry.isOn {
                        Text("on")
                    } else {
                        Text("off")
                    }
                }
                .toggleStyle(.automatic) // ボタン以外はwidgetで動かない。まあ切り替えられればそれでいいので文句はない
                .onAppear {
                    self._isOn = entry.isOn // 値を反映させる
//                    Logger.sendLog(message: "トグル初期化、_isOn", _isOn, "entry.isOn", entry.isOn)
                }
                .onChange(of: self._isOn) { old, new in // TODO: このブロックに機能してほしいが機能しない
                    Logger.sendLog(message: "トグル変更、old", old, "new", new)
                }
            }

//            // ボタン 純粋なインタラクションとして制御されるらしい。このボタンを押されたかどうかというI/Oができるといいんだけど。
//            Button(action: {
//                Logger.sendLog(message: "ボタンをタップした")
//                let scheme = true ? "mywidget://toggleOn" : "mywidget://toggleOff"
//                if let url = URL(string: scheme) {
//                    // WidgetからアプリケーションへURLスキームを送信するためにLinkを使用
//                    _ = Link(destination: url) {
//                        EmptyView()
//                    }.frame(width: 0, height: 0)
//                }
//            }) {
//                Text("ボタンを押すTimer2WidgetEntryView")
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
        }.onTapGesture { // TODO: このブロックに機能してほしいが機能しない
            self._isOn = !self._isOn
            _ = Link(destination: URL(string: "mywidget://toggle")!) {
                Text("スイッチを切り替える")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
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
