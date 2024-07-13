//
//  Logger.swift
//  Timer2
//
//  Created by aimer on 2024/07/13.
//

import Foundation

class Logger {
    static func sendLog(message: Any...) {
        let stringMessages = message.map { String(describing: $0) }
        let concatenatedMessage = stringMessages.joined(separator: " ")
        guard let url = URL(string: "http://127.0.0.1:8000/" + concatenatedMessage) else { return }

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
