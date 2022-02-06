//
//  JPDesignCodeCourseWidget.swift
//  JPDesignCodeCourseWidget
//
//  Created by 周健平 on 2022/2/6.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct JPDesignCodeCourseWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if family == .systemSmall {
            JPDesignCodeCourseSmallWidget(date: entry.date)
        } else {
            JPDesignCodeCourseMediumWidget(date: entry.date)
        }
    }
}

struct JPDesignCodeCourseSmallWidget : View {
    var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Newest")
                Spacer()
                Text(date, style: .time)
            }
            .font(Font.footnote.smallCaps())
            .foregroundColor(.secondary)
            
            Text("Matched Geometry Effect")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text("Learn how to quickly transition different views")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(12)
    }
}

struct JPDesignCodeCourseMediumWidget : View {
    var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Newest")
                Spacer()
                Text(date, style: .time)
            }
            .font(Font.footnote.smallCaps())
            .foregroundColor(.secondary)
            
            ForEach(0 ..< 2) { index in
                CourseRow(item: courseSections[index])
            }
        }
        .padding(12)
    }
}

@main
struct JPDesignCodeCourseWidget: Widget {
    let kind: String = "JPDesignCodeCourseWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            JPDesignCodeCourseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("JPDesignCodeCourse Widget")
        .description("Latest courses and tutorials")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct JPDesignCodeCourseWidget_Previews: PreviewProvider {
    static var previews: some View {
//        JPDesignCodeCourseWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        JPDesignCodeCourseSmallWidget(date: Date())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        JPDesignCodeCourseMediumWidget(date: Date())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
