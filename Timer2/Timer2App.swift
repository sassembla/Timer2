//
//  Timer2App.swift
//  Timer2
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI
import WidgetKit

@main
struct Timer2App: App {
    init() {
        log(message: "起動A")
    }

    @State private var isOn = false

    var body: some Scene {
        WindowGroup {
            ContentView(isOn: $isOn)
                .onOpenURL { url in
                    log(message: "到達")
                    if url.scheme == "mywidget", url.host == "toggle" {
                        isOn.toggle()
                        // ウィジェットの再ロードをトリガーする
                        WidgetCenter.shared.reloadAllTimelines()
                        log(message: "再ロード！")
                    }
                }
        }
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
}
