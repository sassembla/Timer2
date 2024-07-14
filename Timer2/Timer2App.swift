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

    var body: some Scene {
//        Settings {
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
                                    saveIsOnToAppGroup(isOn: next)
                                }
                            }
                        }

                        // ウィジェットの再ロードをトリガーする
                        WidgetCenter.shared.reloadAllTimelines()

                        Logger.sendLog(message: "Timer2Appからの再ロード！ これで要素を更新できる", "url", url)

                        // なんとここで終了させると画面に一切見えずとも動作する、野蛮すぎるのでダメ。
                        // exit(0)
                    }
                }
        }
    }

    func saveIsOnToAppGroup(isOn: Bool) {
        guard let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp") else {
            Logger.sendLog(message: "保存できてない isOn", isOn)
            return
        }

        defaults.set(isOn, forKey: "IsOn")
        let value = defaults.bool(forKey: "IsOn")
        Logger.sendLog(message: "--書き込めた isOn", isOn, "defaults", defaults, "value", value)
    }
}

// App側のコンテンツのビュー、今回は不可視でいいので、値を持たないようにしていく。
// TODO: 一瞬だけめっちゃ小さいインジケーターを画面の真ん中に出せるといいなあって思う。アニメーション表示→hideまでが流れるようにできると良い。
struct ContentView: View {
    var body: some View {
        VStack {}
            .onAppear(perform: {
                // App側のwindowは一切表示されないで欲しいので、開いていればcloseする。
                for window in NSApp.windows {
                    window.close()
                }

                // このコードを実行することでAppがhideされ、次回のwidgetの操作が実行された時、
                // App側でreloadAllTimelinesを実行すると、widget側でgetTimelineがほぼ確実に即座に発生する。
                // hideを実行することで、次のAppの起動がforeground化になり、そのタイミングで確実にwidgetのアップデートが行われているっぽい。exitよりはマシな気配。
                NSApp.hide(nil)
            })
            .onDisappear(perform: {
                exit(0)
            })
            .padding()
    }
}

#Preview {
    ContentView()
}
