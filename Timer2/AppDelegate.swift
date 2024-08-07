////
////  AppDelegate.swift
////  Timer2
////
////  Created by aimer on 2024/07/14.
////
//
// import Cocoa
// import Foundation
// import WidgetKit
//
// @main
// class AppDelegate: NSObject, NSApplicationDelegate {
//    var statusItem: NSStatusItem?
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        // ステータスバーアイテムの作成
//        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//        if let button = statusItem?.button {
//            button.title = "App"
//            button.action = #selector(statusItemClicked(_:))
//        }
//
//        Logger.sendLog(message: "applicationDidFinishLaunching")
//    }
//
//    @objc func statusItemClicked(_ sender: Any?) {
//        // ステータスバーアイテムがクリックされた時のアクション
//        print("ステータスバーアイテムがクリックされました")
//        Logger.sendLog(message: "ステータスバーアイテムがクリックされました") // これは出ない、ちょっとなんでだかはまだわからない。
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        // アプリケーション終了時の処理
//    }
//
//    func application(_ application: NSApplication, open urls: [URL]) {
//        for url in urls {
//            Logger.sendLog(message: "Timer2AppのonOpenURLへと到達", url)
//            if url.scheme == "mywidget", url.host == "toggle" {
//                // クエリパラメータを分解
//                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//                   let queryItems = components.queryItems
//                {
//                    for queryItem in queryItems {
//                        let query = queryItem.name
//                        let value = queryItem.value
//                        if query == "ison" {
//                            guard let isOnCurrent = (value as NSString?)?.boolValue else { continue }
//
//                            let next = !isOnCurrent
//                            Logger.sendLog(message: "isOnCurrent", isOnCurrent, "next", next)
//                            // 次はisOnCurrent が !isOnCurrentになる
//                            saveIsOnToAppGroup(isOn: next)
//                        }
//                    }
//                }
//
//                // ウィジェットの再ロードをトリガーする
//                WidgetCenter.shared.reloadAllTimelines()
//
//                Logger.sendLog(message: "Timer2Appからの再ロード！ これで要素を更新できる。", "url", url)
//            }
//        }
//    }
//
//    func saveIsOnToAppGroup(isOn: Bool) {
//        guard let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp") else {
//            Logger.sendLog(message: "保存できてない isOn", isOn)
//            return
//        }
//
//        defaults.set(isOn, forKey: "IsOn")
//        let value = defaults.bool(forKey: "IsOn")
//        Logger.sendLog(message: "--書き込めた isOn", isOn, "defaults", defaults, "value", value)
//    }
// }
