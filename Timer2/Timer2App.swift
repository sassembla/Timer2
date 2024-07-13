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
    @State private var isOn = false

    var body: some Scene {
        WindowGroup {
            ContentView(isOn: $isOn)
                .onOpenURL { url in
                    Logger.sendLog(message: "Timer2AppのonOpenURLへと到達", url)
                    if url.scheme == "mywidget", url.host == "toggle" {
                        isOn.toggle()

                        // ウィジェットの再ロードをトリガーする
                        WidgetCenter.shared.reloadAllTimelines()

                        Logger.sendLog(message: "Timer2Appからの再ロード！ これで要素を更新できる。 isOn", isOn)
                    }
                }
        }
    }
}
