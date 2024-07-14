//
//  URLSchemeEmitter.swift
//  Timer2
//
//  Created by aimer on 2024/07/14.
//

import Foundation

// projectがサポートしているURLScheme scheme://host?key=value 形式をサポートするURLSchemeジェネレータ
enum URLSchemeEmitter {
    // keyとvalueの組み合わせのみをサポートしている。
    static func emitIdentifiedScheme(scheme: String, host: String, key: String, value: String) -> URL {
        guard let url = URL(string: "" + scheme + "://" + host + "?" + key + "=" + value) else {
            Logger.sendLog(message: "EmitIdentifiedSchemeでURL化に失敗 key", key, "value", value)
            return .userDirectory // 苦し紛れにuser dirを返しています
        }
        return url
    }

    static func readQueryItemsFromURL(url: URL, scheme: String) -> (host: String, keyValue: [URLQueryItem])? {
        if url.scheme == scheme {
            guard let host = url.host else {
                Logger.sendLog(message: "該当しないhost", url)
                return nil
            }

            // これ以降は分解成功のルート

            // コンポーネントを分解、host以降のパラメータがない場合ここでhostと空のパラメータが返る
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return (host, [])
            }

            // コンポーネントからクエリアイテムを取り出して返す、クエリがない場合hostと空のパラメータが返る
            guard let queryItems = components.queryItems else {
                return (host, [])
            }

            return (host, queryItems)
        }

        Logger.sendLog(message: "該当しないscheme", url)
        return nil
    }
}
