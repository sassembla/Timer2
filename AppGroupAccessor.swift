//
//  AppGroupAccessor.swift
//  Timer2
//
//  Created by aimer on 2024/07/14.
//

import Foundation

enum AppGroupAccessor {
    // key valueで保存する関数
    static func writeToAppGroupUserDefaults(appGroupSuiteName: String, key: String, value: Any) {
        guard let defaults = UserDefaults(suiteName: appGroupSuiteName) else {
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
    static func readFromAppGroupUserDefaults<T>(appGroupSuiteName: String, forKey: String, as type: T.Type) -> T? {
        // TODO: AppGroupのファイルアクセス共有のための定数にする
        guard let defaults = UserDefaults(suiteName: appGroupSuiteName) else {
            Logger.sendLog(message: "読み出すためにアクセスすることができなかった。AppGroupの設定が怪しい。forKey", forKey)
            return nil
        }

        // NOTE: readに関わるtargetが正しく一致するAppGroupの設定を持っていないと、readは成功するが正しい値が読み取れない、という地獄のような状態になる。
        // trueで入れたはずがfalseになる、などが発生したら、AppGroupを疑うといい。

        // 型に応じて値を読み取る
        switch type {
        case is Bool.Type:
            return defaults.bool(forKey: forKey) as? T
        case is Int.Type:
            return defaults.integer(forKey: forKey) as? T
        case is Float.Type:
            return defaults.float(forKey: forKey) as? T
        case is Double.Type:
            return defaults.double(forKey: forKey) as? T
        case is String.Type:
            return defaults.string(forKey: forKey) as? T
        case is Data.Type:
            return defaults.data(forKey: forKey) as? T
        default:
            Logger.sendLog(message: "サポートされていない型: \(type) の値を読もうとした。 forKey", forKey)
            return nil
        }
    }
}
