import SwiftUI
import TDCore
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScheduleEntry {
        ScheduleEntry(date: Date(), lastWriteDate: Date(), count: 12)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> ()) {
        let entry = ScheduleEntry(date: Date(), lastWriteDate: Date(), count: 12)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let now = Date()
        let snapshot = TDDiaryUtils.fetchDiaryData()
        let entry = ScheduleEntry(date: now, lastWriteDate: snapshot.lastWriteDate, count: snapshot.count)

        let next = TDDiaryUtils.nextHourlyTrigger(after: now)

        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

struct ScheduleEntry: TimelineEntry {
    var date: Date // 현재 Reload 되는 시점
    let lastWriteDate: Date? // 마지막 작성일
    let count: Int // 여태 쓴 일기 작성 개수
}

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            EmptyView()
        default:
            EmptyView()
        }
    }
}

struct ScheduleWidget: Widget {
    let kind: String = WidgetConstant.diary.kindIdentifier

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ScheduleWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ScheduleWidgetEntryView(entry: entry)
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("토덕 - To.duck")
        .description("예정된 일정을 확인하고, 일정을 추가해보세요.")
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    ScheduleWidget()
} timeline: {
    let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let now = Date()
    ScheduleEntry(date: Date(), lastWriteDate: yesterDay, count: 14)
}
