//
//  AppGroupAccessor.swift
//  Timer2
//
//  Created by aimer on 2024/07/14.
//

import Foundation

enum AppGroupAccessor {
    // key valueで保存する関数
    static func writeToAppGroupUserDefaults(key: String, value: Any) {
        // TODO: 切り出す
        guard let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp") else {
            Logger.sendLog(message: "保存できてない key", key)
            return
        }

        // Any型の値を文字列に変換可能かチェック
        let stringValue: String? =
            if let value = value as? String
        {
            value
        } else if let value = value as? Bool {
            String(value)
        } else if let value = value as? Int {
            String(value)
        } else if let value = value as? Double {
            String(value)
        } else {
            nil
        }

        guard let stringValue = stringValue else {
            Logger.sendLog(message: "stringに変換できない型が来たので、保存できてない key", key)
            return
        }

        // 保存する
        defaults.set(stringValue, forKey: key)
    }

    // key valueで保存してあるパラメータを読み出す。
    static func readFromAppGroupUserDefaults(forKey: String) -> Bool? {
        // TODO: AppGroupのファイルアクセス共有のための定数にする
        guard let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp") else {
            Logger.sendLog(message: "読み出すためにアクセスすることができなかった。AppGroupの設定が怪しい。forKey", forKey)
            return nil
        }

        // NOTE: readに関わるtargetが正しく一致するAppGroupの設定を持っていないと、readは成功するが正しい値が読み取れない、という地獄のような状態になる。
        // trueで入れたはずがfalseになる、などが発生したら、AppGroupを疑うといい。

        if true {
            return defaults.bool(forKey: forKey)
        }

        return nil
    }
}
