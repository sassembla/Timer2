//
//  TimerWidLiveActivity.swift
//  TimerWid
//
//  Created by aimer on 2024/07/13.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimerWidLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerWidAttributes {
    fileprivate static var preview: TimerWidAttributes {
        TimerWidAttributes(name: "World")
    }
}

extension TimerWidAttributes.ContentState {
    fileprivate static var smiley: TimerWidAttributes.ContentState {
        TimerWidAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TimerWidAttributes.ContentState {
         TimerWidAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TimerWidAttributes.preview) {
   TimerWidLiveActivity()
} contentStates: {
    TimerWidAttributes.ContentState.smiley
    TimerWidAttributes.ContentState.starEyes
}
