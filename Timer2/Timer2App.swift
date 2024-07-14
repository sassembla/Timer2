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
        // Logger.sendLog(message: "Timer2Appの起動コードに到達")
    }

    var body: some Scene {
//        Settings {// ウィンドウを出さない形のアプリケーションにすると、なんとonOpenが発生しない。これはAppDelegateに切り替えた場合でも発生していて、難しい。Windowを出すと必ず動作する。
        WindowGroup {
            ContentView()
        }
    }
}

// TODO: Appの画面。今は表示後即一瞬だけめっちゃ小さいインジケーターを画面の真ん中に出せるといいなあって思う。アニメーション表示→hideまでが流れるようにできると良い。
struct ContentView: View {
    var body: some View {
        VStack {}
            .onAppear(perform: {
                // App側のwindowは一切表示されないで欲しいので、開いていればcloseする。
                for window in NSApp.windows {
                    window.close()
                }

                // NOTE: このコードを実行することでAppがhideされ、次回のwidgetの操作が実行された時、
                // App側でreloadAllTimelinesを実行すると、widget側でgetTimelineがほぼ確実に即座に発生する。
                // hideを実行することで、次のAppの起動がforeground化になり、そのタイミングで確実にwidgetのアップデートが行われているっぽい。exitよりはマシな気配。
                NSApp.hide(nil)
            })
            // URLSchemeの受け取りコード
            // TODO: AppDelegateに書き換えると飛んでこない、、ということが起きる。原因は絞れてないが、ここにonOpenURLを書かない方がいいのは間違いないので、そのうち。
            .onOpenURL { url in

                // mywidget://toggle?ison=true などが来る
                // TODO: ボタン単位でのイベント名とその値をURLSchemeに仕込むことができるので、read-writeを行う部分を関数化しよう。
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

                                // 送り込まれてきた値を反転した値を書き込む。こうすることで、UIの状態をそのまま入力として信じることができる。
                                let next = !isOnCurrent
                                Logger.sendLog(message: "isOnCurrent", isOnCurrent, "next", next)

                                // 書き込みを行う
                                AppGroupAccessor.writeToAppGroupUserDefaults(key: "IsOn", value: next)
                            }
                        }
                    }

                    // ウィジェットの再ロードをトリガーする
                    WidgetCenter.shared.reloadAllTimelines()

                    Logger.sendLog(message: "Timer2Appからの再ロード！ これで要素を更新できる", "url", url)
                }
            }
    }
}

#Preview {
    ContentView()
}
