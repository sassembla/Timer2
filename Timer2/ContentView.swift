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
                Logger.sendLog(message: "App側のContentViewのボタンが押された")
            }) {
                Text("ボタンを押すContentView")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear(perform: {
            Logger.sendLog(message: "App側のContentViewが表示された")
        })
        .padding()
    }
}

#Preview {
    ContentView(isOn: .constant(false))
}
