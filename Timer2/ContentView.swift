//
//  ContentView.swift
//  Timer2
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI

// App側のコンテンツのビュー、今回は不可視でいいので、値を持たないようにしていく。
// TODO: 一瞬だけめっちゃ小さいインジケーターを画面の真ん中に出せるといいなあって思う。
struct ContentView: View {
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello,world!")
//            Button(action: {
            ////                showAlert = true
//                Logger.sendLog(message: "App側のContentViewのボタンが押された")
//            }) {
//                Text("ボタンを押すContentView")
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
        }
        .onAppear(perform: {
            Logger.sendLog(message: "App側のContentViewが表示された")

            for window in NSApp.windows {
                window.close()
                Logger.sendLog(message: "closeしてる")
            }

            // hideを実行するタイミングで確実にwidgetのアップデートが行われているっぽい。exitよりはマシな気配。
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
