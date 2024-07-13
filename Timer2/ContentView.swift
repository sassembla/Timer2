//
//  ContentView.swift
//  Timer2
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI

struct ContentView: View {
    @Binding var isOn: Bool

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello,world!")
            Button(action: {
//                showAlert = true
                Logger.sendLog(message: "ffffff")
            }) {
                Text("ボタンを押すContentView")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func sendHTTPRequest() {
        guard let url = URL(string: "http://127.0.0.1:8000") else { return }

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

#Preview {
    ContentView(isOn: .constant(false))
}
