//
//  Widget.swift
//  Widget
//
//  Created by Apollo Zhu on 5/22/21.
//  Copyright © 2021 DMV A-Z. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import AZDMVShared

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    quiz: quizzes.randomElement()!,
                    configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                quiz: quizzes.randomElement()!,
                                configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,
                                    quiz: quizzes.randomElement()!,
                                    configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date

    let quiz: Quiz
    let image: Image?
    let configuration: ConfigurationIntent

    init(date: Date, quiz: Quiz, configuration: ConfigurationIntent) {
        self.quiz = quiz
        self.image = quiz.imageURL.flatMap {
            try? Data(contentsOf: $0)
        }
        .flatMap(UIImage.init)
        .map(Image.init)
        self.date = date
        self.configuration = configuration
    }
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                Text(entry.quiz.question)
                Spacer()
                Text(entry.quiz.correctAnswer.text)
                    .fontWeight(.bold)
                Spacer()
            }
            VStack {
                Spacer()
                if let image = entry.image {
                    image
                        .aspectRatio(1, contentMode: .fit)
                }
                Spacer()
                Spacer()
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

@main
struct AZDMVWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Driving Quizzes")
        .description("Review important questions.")
    }
}

struct AZDMVWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(),
                                           quiz: quizzes.randomElement()!,
                                           configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
