//
//  Logger.swift
//  Timer2
//
//  Created by aimer on 2024/07/13.
//

import Foundation

class Logger {
    static func sendLog(message: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/" + message) else { return }

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
}
