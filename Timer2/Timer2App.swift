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
        Logger.sendLog(message: "起動A")
    }

    @State private var isOn = false

    var body: some Scene {
        WindowGroup {
            ContentView(isOn: $isOn)
                .onOpenURL { url in
                    Logger.sendLog(message: "到達")
                    if url.scheme == "mywidget", url.host == "toggle" {
                        isOn.toggle()
                        // ウィジェットの再ロードをトリガーする
                        WidgetCenter.shared.reloadAllTimelines()
                        Logger.sendLog(message: "再ロード！")
                    }
                }
        }
    }
}
