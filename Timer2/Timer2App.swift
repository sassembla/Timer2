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
        Logger.sendLog(message: "Timer2Appの起動コードに到達")
    }

    // オンメモリで保持する値
    private var isOn = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 受け取り側のコード
                .onOpenURL { url in
                    Logger.sendLog(message: "Timer2AppのonOpenURLへと到達", url)
                    if url.scheme == "mywidget", url.host == "toggle" {
                        // クエリパラメータを分解
                        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                           let queryItems = components.queryItems
                        {
                            for queryItem in queryItems {
                                let query = queryItem.name
                                let value = queryItem.value
                                if query == "ison" {
                                    guard let isOnCurrent = (value as? NSString)?.boolValue else { continue }

                                    let next = !isOnCurrent
                                    Logger.sendLog(message: "isOnCurrent", isOnCurrent, "next", next)
                                    // 次はisOnCurrent が !isOnCurrentになる
                                    saveIsOnToAppGroup(next)
                                }
                            }
                        }

                        // ウィジェットの再ロードをトリガーする
                        WidgetCenter.shared.reloadAllTimelines()

                        Logger.sendLog(message: "Timer2Appからの再ロード！ これで要素を更新できる。 isOn", isOn, "url", url)
                    }
                }
        }
    }

    func saveIsOnToAppGroup(_ isOn: Bool) {
        let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp")
        defaults?.set(isOn, forKey: "IsOn")
    }
}
