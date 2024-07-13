//
//  Timer2WidgetBundle.swift
//  Timer2Widget
//
//  Created by aimer on 2024/07/13.
//

import SwiftUI
import WidgetKit

@main
struct Timer2WidgetBundle: WidgetBundle {
    init() {
        Logger.sendLog(message: "widget")
    }

    var body: some Widget {
        Timer2Widget()
    }
}
