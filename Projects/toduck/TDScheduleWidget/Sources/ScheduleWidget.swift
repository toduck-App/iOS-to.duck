import SwiftUI
import TDCore
import TDDesign
import TDDomain
import WidgetKit

// MARK: - Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScheduleEntry {
        ScheduleEntry(date: Date(), scheduleList: ScheduleEntry.sample)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> ()) {
        let entry = ScheduleEntry(date: Date(), scheduleList: ScheduleEntry.sample)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEntry>) -> ()) {
        let now = Date()
        let entry = ScheduleEntry(date: now, scheduleList: ScheduleEntry.sample)
        let next = Calendar.current.nextHour(after: now)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

// MARK: - Entry

struct ScheduleEntry: TimelineEntry {
    var date: Date
    let scheduleList: [Schedule]
}

// MARK: - Views

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            let todays = remainingTodos(from: entry.scheduleList, on: entry.date)
            let firstToday = todays.first

            SmallScheduleCardView(
                dayText: dayString(entry.date),
                weekdayText: weekdayString(entry.date),
                title: firstToday?.title ?? "오늘\n일정이 없어요",
                timeText: timeString(firstToday),
                accentColor: firstToday == nil ? TDColor.NeutralSwiftUI.neutral500 : TDColor.ScheduleSwiftUI.text6,
                bgColor: firstToday == nil ? TDColor.NeutralSwiftUI.neutral100 : TDColor.ScheduleSwiftUI.back6,
                icon: firstToday == nil ? TDWidgetImage.Schedule.noSchedule : TDImage.CategorySwiftUI.computer
            )

        case .systemMedium:
            GeometryReader { geo in
                HStack(alignment: .top, spacing: 12) {
                    let todays = remainingTodos(from: entry.scheduleList, on: entry.date)
                    let firstToday = todays.first

                    SmallScheduleCardView(
                        dayText: dayString(entry.date),
                        weekdayText: weekdayString(entry.date),
                        title: firstToday?.title ?? "오늘\n일정이 없어요",
                        timeText: timeString(firstToday),
                        accentColor: firstToday == nil ? TDColor.NeutralSwiftUI.neutral500 : TDColor.ScheduleSwiftUI.text6,
                        bgColor: firstToday == nil ? TDColor.NeutralSwiftUI.neutral100 : TDColor.ScheduleSwiftUI.back6,
                        icon: firstToday == nil ? TDWidgetImage.Schedule.noSchedule : TDImage.CategorySwiftUI.computer
                    )
                    .frame(width: geo.size.width * 0.45)

                    let ctx = rightPaneContext(for: entry)
                    TodoListView(
                        title: ctx.date.map { $0.convertToString(formatType: .monthDayWithWeekday) } ?? "",
                        items: ctx.items,
                        maxCount: 4
                    )
                    .frame(width: geo.size.width * 0.55)
                }
            }

        default:
            EmptyView()
        }
    }

    // MARK: - Helpers (공용)

    private func rightPaneContext(for entry: ScheduleEntry) -> (date: Date?, items: [Schedule]) {
        let todays = remainingTodos(from: entry.scheduleList, on: entry.date)
        if !todays.isEmpty {
            return (entry.date, todays)
        }
        if let nextDate = nearestFutureDateWithTodos(from: entry.date, in: entry.scheduleList) {
            return (nextDate, remainingTodos(from: entry.scheduleList, on: nextDate))
        }
        return (nil, [])
    }

    /// 특정 날짜의 미완료 스케줄만 필터 + 시간순 정렬
    private func remainingTodos(from list: [Schedule], on date: Date) -> [Schedule] {
        let key = DateFormatter.yyyyMMdd.string(from: date)
        return list
            .filter { !$0.isFinished }
            .filter { $0.startDate <= key && key <= $0.endDate }
            .sorted { lhs, rhs in
                switch (lhs.time, rhs.time) {
                case let (lt?, rt?): return lt < rt
                case (nil, _?): return false
                case (_?, nil): return true
                default: return lhs.title < rhs.title
                }
            }
    }

    /// 오늘 이후(내일 포함) 중 '미완료 스케줄이 존재하는 가장 이른 날짜' 계산
    private func nearestFutureDateWithTodos(from base: Date, in list: [Schedule]) -> Date? {
        let cal = Calendar.current
        let tomorrow = cal.date(byAdding: .day, value: 1, to: base)!
        let startOfTomorrow = cal.startOfDay(for: tomorrow)

        var candidates: [Date] = []

        for s in list where !s.isFinished {
            guard
                let start = Date.convertFromString(s.startDate, format: .yearMonthDay),
                let end = Date.convertFromString(s.endDate, format: .yearMonthDay)
            else { continue }

            let firstValid = max(cal.startOfDay(for: start), startOfTomorrow)
            if firstValid <= cal.startOfDay(for: end) {
                candidates.append(firstValid)
            }
        }

        return candidates.min()
    }

    private func dayString(_ date: Date) -> String {
        Calendar.current.component(.day, from: date).description
    }

    private func weekdayString(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko_KR")
        fmt.dateFormat = "E"
        return fmt.string(from: date)
    }

    private func monthDayString(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko_KR")
        fmt.dateFormat = "M월 d일 (E)"
        return fmt.string(from: date)
    }

    private func timeString(_ schedule: Schedule?) -> String? {
        guard let t = schedule?.time else { return nil }
        return Date.convertFromString(t, format: .time24Hour)?
            .convertToString(formatType: .time24Hour)
    }
}

// MARK: - Reusable Small Card (좌측)

struct SmallScheduleCardView: View {
    let dayText: String
    let weekdayText: String
    let title: String
    let timeText: String?
    let accentColor: Color
    let bgColor: Color
    let icon: Image

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 4) {
                Text(dayText)
                    .customFont(.pretendardSemiBold, size: 24)
                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral900)
                Text(weekdayText)
                    .customFont(.pretendardSemiBold, size: 20)
                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral900)
            }
            .frame(width: .infinity, height: 24, alignment: .topLeading)
            .padding(.bottom, 12)

            Rectangle()
                .fill(bgColor)
                .cornerRadius(10)
                .overlay(alignment: .topLeading) {
                    HStack {
                        Rectangle()
                            .fill(accentColor)
                            .frame(width: 2, height: 28)
                            .cornerRadius(1)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .foregroundStyle(accentColor)
                                .customFont(.pretendardSemiBold, size: 14)
                                .lineLimit(2)
                            if let timeText {
                                Text(timeText)
                                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral800)
                                    .customFont(.pretendardMedium, size: 10)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 12)
                }
                .overlay(alignment: .bottomTrailing) {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .padding(.bottom, 6)
                        .padding(.trailing, 12)
                }
        }
    }
}

// MARK: - Right Pane (투두 리스트)

struct TodoListView: View {
    let title: String
    let items: [Schedule]
    let maxCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.pretendardSemiBold, size: 12)
                .foregroundStyle(TDColor.NeutralSwiftUI.neutral600)
                .frame(width: .infinity, height: 24, alignment: .center)
                .padding(.bottom, 12)

            if items.isEmpty {
                Text("예정된 일정이 없어요 !")
                    .customFont(.pretendardMedium, size: 12)
                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral500)
            } else {
                ForEach(items.prefix(maxCount), id: \.id) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Rectangle()
                            .fill(Color(hex: item.category.colorHex) ?? TDColor.NeutralSwiftUI.neutral400)
                            .frame(width: 2, height: 16)
                            .cornerRadius(1)

                        Text(item.title)
                            .customFont(.pretendardMedium, size: 12)
                            .foregroundStyle(TDColor.NeutralSwiftUI.neutral900)
                            .lineLimit(1)
                    }
                    .frame(height: 20)
                    .padding(.bottom, 6)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Widget

struct ScheduleWidget: Widget {
    let kind: String = WidgetConstant.diary.kindIdentifier

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Group {
                if #available(iOS 17.0, *) {
                    ScheduleWidgetEntryView(entry: entry)
                        .containerBackground(.fill.tertiary, for: .widget)
                        .padding(16)
                } else {
                    ScheduleWidgetEntryView(entry: entry)
                        .background()
                        .padding(16)
                }
            }
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("토덕 - To.duck")
        .description("예정된 일정을 확인하고, 일정을 추가해보세요.")
        .contentMarginsDisabled()
    }
}

// MARK: - Previews

#Preview(as: .systemMedium) {
    ScheduleWidget()
} timeline: {
    ScheduleEntry(date: Date(), scheduleList: ScheduleEntry.sample)
}

// MARK: - Utils

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "ko_KR")
        f.timeZone = .current
        return f
    }()
}

extension ScheduleEntry {
    static let sample: [Schedule] = [
        Schedule(
            id: 1,
            title: "팀 회의",
            category: .init(colorHex: "#4C6EF5", imageName: "computer"),
            startDate: "2025-08-25",
            endDate: "2025-08-25",
            isAllDay: false,
            time: "11:00",
            repeatDays: nil,
            alarmTime: .oneDayBefore,
            place: "회의실 A",
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        Schedule(
            id: 2,
            title: "UI 작업",
            category: .init(colorHex: "#FFA94D", imageName: "book"),
            startDate: "2025-08-27",
            endDate: "2025-08-27",
            isAllDay: false,
            time: "13:30",
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        Schedule(
            id: 3,
            title: "점심 약속",
            category: .init(colorHex: "#51CF66", imageName: "food"),
            startDate: "2025-08-27",
            endDate: "2025-08-27",
            isAllDay: false,
            time: "12:30",
            repeatDays: nil,
            alarmTime: nil,
            place: "카페 더덕",
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        ),
        Schedule(
            id: 4,
            title: "영화 보기",
            category: .init(colorHex: "#748FFC", imageName: "food"),
            startDate: "2025-08-27",
            endDate: "2025-08-27",
            isAllDay: true,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
    ]
}
