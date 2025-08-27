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
            // 오늘 일정이 있는 경우
            if let firstToday = todays.first {
                SmallScheduleCardView(
                    date: entry.date,
                    time: firstToday.time,
                    isAllDay: firstToday.isAllDay,
                    title: firstToday.title,
                    accentColor: Color.getAccentColor(for: firstToday.category) ?? .white,
                    bgColor: Color(hex: firstToday.category.colorHex) ?? .white,
                    icon: TDWidgetImage.Category(firstToday.category.imageName).swiftUIImage
                )
            }
            // 오늘 일정이 없는 경우
            else {
                SmallScheduleCardView(
                    date: entry.date,
                    time: nil,
                    isAllDay: false,
                    title: "오늘\n일정이 없어요",
                    accentColor: TDColor.NeutralSwiftUI.neutral500,
                    bgColor: TDColor.NeutralSwiftUI.neutral100,
                    icon: TDWidgetImage.Schedule.noSchedule
                )
            }

        case .systemMedium:
            GeometryReader { geo in
                HStack(alignment: .top, spacing: 12) {
                    let todays = remainingTodos(from: entry.scheduleList, on: entry.date)
                    let leftCard = todays.first

                    if let firstToday = leftCard {
                        SmallScheduleCardView(
                            date: entry.date,
                            time: firstToday.time,
                            isAllDay: firstToday.isAllDay,
                            title: firstToday.title,
                            accentColor: Color.getAccentColor(for: firstToday.category) ?? .white,
                            bgColor: Color(hex: firstToday.category.colorHex) ?? .white,
                            icon: TDWidgetImage.Category(firstToday.category.imageName).swiftUIImage
                        )
                        .frame(width: geo.size.width * 0.45)
                    } else {
                        SmallScheduleCardView(
                            date: entry.date,
                            time: nil,
                            isAllDay: false,
                            title: "오늘\n일정이 없어요",
                            accentColor: TDColor.NeutralSwiftUI.neutral500,
                            bgColor: TDColor.NeutralSwiftUI.neutral100,
                            icon: TDWidgetImage.Schedule.noSchedule
                        )
                        .frame(width: geo.size.width * 0.45)
                    }
                    let ctx = rightPaneContext(for: entry)

                    let listTitle: String = {
                        guard let ctxDate = ctx.date else { return "투두" }
                        return Calendar.current.isDateInToday(ctxDate)
                            ? "투두"
                            : ctxDate.convertToString(formatType: .monthDayWithWeekday)
                    }()
                    let rightItems: [Schedule] = {
                        guard let ctxDate = ctx.date else { return [] }
                        if let left = leftCard,
                           Calendar.current.isDate(ctxDate, inSameDayAs: entry.date)
                        {
                            return ctx.items.filter { $0.id != left.id }
                        }
                        return ctx.items
                    }()

                    TodoListView(
                        title: listTitle,
                        items: rightItems,
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

    private func rightPaneContext(
        for entry: ScheduleEntry
    ) -> (
        date: Date?,
        items: [Schedule]
    ) {
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
    private func remainingTodos(
        from list: [Schedule],
        on date: Date
    ) -> [Schedule] {
        let key = date.convertToString(formatType: .yearMonthDay)
        return list
            .filter { !$0.isFinished }
            .filter { $0.startDate <= key && key <= $0.endDate }
            .sorted { lhs, rhs in
                switch (lhs.time, rhs.time) {
                case let (lt?, rt?): lt < rt
                case (nil, _?): false
                case (_?, nil): true
                default: lhs.title < rhs.title
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
}

// MARK: - Reusable Small Card (좌측)

struct SmallScheduleCardView: View {
    let date: Date
    let time: String?
    let isAllDay: Bool
    let title: String
    let accentColor: Color
    let bgColor: Color
    let icon: Image

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 4) {
                Text(date.convertToString(formatType: .day))
                    .tdFont(.boldHeader2)
                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral900)
                Text(date.convertToString(formatType: .weekdayShort))
                    .tdFont(.boldHeader3)
                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral900)
            }
            .frame(width: .infinity, height: 24, alignment: .topLeading)
            .padding(.bottom, 12)

            RoundedRectangle(cornerRadius: 10)
                .fill(bgColor)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .foregroundStyle(accentColor)
                            .tdFont(.boldBody2)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)

                        Text(isAllDay ? "종일" : (time ?? ""))
                            .foregroundStyle(TDColor.NeutralSwiftUI.neutral800)
                            .tdFont(.mediumCaption2)
                            .lineLimit(1)
                    }
                    .padding(.leading, 6)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(accentColor)
                            .frame(width: 2)
                            .frame(maxHeight: .infinity)
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
                .tdFont(.boldCaption1)
                .foregroundStyle(TDColor.NeutralSwiftUI.neutral600)
                .frame(width: .infinity, height: 24, alignment: .center)
                .padding(.bottom, 12)

            if items.isEmpty {
                Text("예정된 일정이 없어요 !")
                    .tdFont(.boldCaption1)
                    .foregroundStyle(TDColor.NeutralSwiftUI.neutral500)
            } else {
                ForEach(items.prefix(maxCount), id: \.id) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Rectangle()
                            .fill(Color.getAccentColor(for: item.category) ?? TDColor.NeutralSwiftUI.neutral300)
                            .frame(width: 2, height: 16)
                            .cornerRadius(1)

                        Text(item.title)
                            .tdFont(.mediumCaption1)
                            .foregroundStyle(TDColor.NeutralSwiftUI.neutral700)
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
                        .containerBackground(for: .widget) {
                            Color.white
                        }
                } else {
                    ScheduleWidgetEntryView(entry: entry)
                        .background()
                }
            }
            .padding(16)
            .widgetURL(URL(string: "toduck://diary")!)
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

extension ScheduleEntry {
    static let sample: [Schedule] = [
        Schedule(
            id: 1,
            title: "팀 회의",
            category: .init(colorHex: "#DEEEFC", imageName: "computer"),
            startDate: "2025-08-23",
            endDate: "2025-08-26",
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
            category: .init(colorHex: "#DEEEFC", imageName: "book"),
            startDate: "2025-08-22",
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
            category: .init(colorHex: "#DEEEFC", imageName: "food"),
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
            category: .init(colorHex: "#FFF7D9", imageName: "food"),
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
