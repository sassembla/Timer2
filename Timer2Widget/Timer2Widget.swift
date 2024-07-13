//
//  Timer2Widget.swift
//  Timer2Widget
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func log(message: String) {
        sendHTTPRequest()
//        let filePath = "/Users/aimer/Desktop/Timer2/app.log"
//        let fileURL = URL(fileURLWithPath: filePath)
//
//        do {
//            // ファイルが存在しない場合は新規作成し、存在する場合は追記
//            if FileManager.default.fileExists(atPath: filePath) {
//                if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
//                    fileHandle.seekToEndOfFile()
//                    if let data = (message + "\n").data(using: .utf8) {
//                        fileHandle.write(data)
//                    }
//                    fileHandle.closeFile()
//                }
//            } else {
//                try message.write(to: fileURL, atomically: true, encoding: .utf8)
//            }
//            print("Successfully wrote to file at path: \(filePath)")
//        } catch {
//            print("Failed to write to file with error: \(error)")
//        }
    }

    func sendHTTPRequest() {
        guard let url = URL(string: "http://127.0.0.1:8000") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("HTTPリクエストエラー: \(error.localizedDescription)")
                return
            }

            if let data = data {
                print("HTTPレスポンスデータ: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }

    func placeholder(in context: Context) -> SimpleEntry {
        log(message: "here")
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
        Logger.sendLog(message: "起動")
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
//                log(message: "Button was tapped")
            }) {
                Text("ボタンを押す")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text("アラートタイトル"),
                    message: Text("これはアラートメッセージです。"),
                    dismissButton: .default(Text("OK"))
                )
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
