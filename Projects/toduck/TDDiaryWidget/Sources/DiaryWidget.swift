import SwiftUI
import TDCore
import WidgetKit

struct Provider: TimelineProvider {
    /*
     위젯의 미리보기 상태를 설정할 수 있다.
     사용자가 위젯을 추가하기 전에 기본적으로 보이는 UI 상태를 제공한다.
     보통은 Date()로 현재 시간을 넣고, 기본 설정값을 적용한다. → 필요에 따라 커스텀
     */
    func placeholder(in context: Context) -> DiaryEntry {
        DiaryEntry(date: Date(), lastWriteDate: Date(), count: 12)
    }

    /*
     위젯 갤러리에서 스냅샷을 생성할 때 사용된다.
     보통 timeline()과 유사하지만, 빠르게 표시할 수 있는 기본 데이터를 제공한다는 특징을 가진다.
     앱에서 즉시 보여줄 수 있는 데이터를 반환하는 역할이다.
     */
    func getSnapshot(in context: Context, completion: @escaping (DiaryEntry) -> ()) {
        let entry = DiaryEntry(date: Date(), lastWriteDate: Date(), count: 12)
        completion(entry)
    }

    /*
     위젯이 주기적으로 업데이트할 데이터를 제공한다.
     entries 배열을 생성해서, 시간대별로 다른 데이터를 보여줄 수 있다.
     policy 설정을 통해 언제 데이터를 갱신할지 결정 가능:
     .atEnd: 마지막 엔트리 이후에 새로운 타임라인을 요청
     .after(Date): 특정 시간이 지나면 다시 갱신
     .never: 갱신 없이 한 번만 설정
     */
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let cal = Calendar.current
        let now = Date()

        let today9 = Utils.make(hour: 21, from: now)
        let today10 = Utils.make(hour: 22, from: now)
        let today11 = Utils.make(hour: 23, from: now)

        var schedule = [today9, today10, today11].filter { $0 > now }
        if schedule.isEmpty {
            let tomorrow = cal.date(byAdding: .day, value: 1, to: now)!
            schedule = [Utils.make(hour: 21, from: tomorrow),
                        Utils.make(hour: 22, from: tomorrow),
                        Utils.make(hour: 23, from: tomorrow)]
        }

        var entries: [DiaryEntry] = []
        func makeEntry(at date: Date) -> DiaryEntry {
            // TODO: 실제로는 App Group 캐시에서 가져와야 함
            let count = 0
            let lastWriteDate: Date? = nil
            return DiaryEntry(date: date, lastWriteDate: lastWriteDate, count: count)
        }

        entries.append(makeEntry(at: now))

        for when in schedule {
            entries.append(makeEntry(at: when))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    /*
     위젯의 중요도를 설정할 수 있다.
     iOS는 중요도가 높은 위젯을 더 자주 업데이트하거나, 우선적으로 표시할 수 있다.
     사용자가 앱을 사용할 때 어떤 컨텍스트에서 위젯을 강조할지 설정 가능하다.
     기본적으로 주석 처리가 되어있다.
     */
//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

/*
 표시할 데이터를 저장하는 모델이다.
 즉, 위젯이 화면에 나타날 때 필요한 정보(날짜, 텍스트 등)를 담는 데이터 구조체이다.
 모든 위젯 엔트리는 TimelineEntry 프로토콜을 준수해야만 한다.

 TimelineEntry 프로토콜을 채택하며, date 속성을 포함해야 함 → date = 업데이트 주기
 getTimeline()에서 여러 개의 Entry를 생성해 위젯을 업데이트할 수 있음
 */
struct DiaryEntry: TimelineEntry {
    var date: Date // 현재 Reload 되는 시점
    let lastWriteDate: Date? // 마지막 작성일
    let count: Int // 여태 쓴 일기 작성 개수

    // 오늘 작성한 일기가 있다면 true 반환
    var wroteToday: Bool {
        guard let last = lastWriteDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    // "어제(1일) 이상 밀린 일기 개수"
    var procrastinatedDays: Int {
        guard let last = lastWriteDate else { return 0 }
        let cal = Calendar.current
        let lastDay = cal.startOfDay(for: last)
        let baseDay = cal.startOfDay(for: date)
        let gap = cal.dateComponents([.day], from: lastDay, to: baseDay).day ?? 0
        return max(0, gap) // 미래 날짜가 들어와 음수가 되지 않도록 방어
    }

    // "어제(1일) 이상 밀렸으면 true"
    var isProcrastinating: Bool {
        procrastinatedDays >= 1
    }

    var visableCount: Int {
        isProcrastinating ? 0 : count
    }

    // 경고 아이콘 표시 여부
    var isDangerous: Bool {
        // 오늘 작성한 일기가 없고, 현재 시간이 오후 10시 이후인 경우
        wroteToday == false && Calendar.current.component(.hour, from: date) >= 22
    }

    var state: State {
        if isDangerous { return .C_danger }

        if lastWriteDate == nil { return .A_neverWritten }

        if isProcrastinating { return .D_procrastinating }

        return .B_active
    }

    var visableImage: Image {
        switch state {
        case .A_neverWritten:
            return [
                TDWidgetImage.Diary.A1,
                TDWidgetImage.Diary.A2,
                TDWidgetImage.Diary.A3,
            ].randomElement()!
        case .B_active:
            let images = [
                TDWidgetImage.Diary.B1,
                TDWidgetImage.Diary.B2,
                TDWidgetImage.Diary.B3,
            ]
            let res = images[count % images.count]
            return res
        case .C_danger:
            let images =
                [
                    TDWidgetImage.Diary.C1,
                    TDWidgetImage.Diary.C2,
                    TDWidgetImage.Diary.C3,
                ]
            let res = images[count % images.count]
            return res
        case .D_procrastinating:
            let images =
                [
                    TDWidgetImage.Diary.D1,
                    TDWidgetImage.Diary.D2,
                    TDWidgetImage.Diary.D3,
                ]
            let res = images[count % images.count]
            return res
        }
    }

    /* 위젯에서 보여줄 일기 작성 개수
     오늘 작성한 일기가 있다면 count, 아니면 0
      */

    enum State {
        case A_neverWritten // A: 일기를 한번도 작성하지 않은 상태
        case B_active // B: 꾸준히 작성중인 상태
        case C_danger // C: 오후 10시 이후 작성하지 않은 상태
        case D_procrastinating // D: 미루기 시작한 상태
    }
}

struct DiaryWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack(alignment: .top) {
                entry.visableImage

                VStack {
                    HStack(alignment: .center, spacing: 6) {
                        TDWidgetImage.tomato
                            .frame(width: 44, height: 44)
                            .overlay(alignment: .bottomTrailing) {
                                if entry.isDangerous {
                                    TDWidgetImage.error
                                        .frame(width: 24, height: 24)
                                }
                            }

                        Text("\(entry.visableCount)")
                            .customFont(.pretendardSemiBold, size: 30)
                            .monospacedDigit()
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .allowsTightening(true)
                            .opacity(0.7)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 16)

                    Text("오늘을 기록하세요!")
                        .customFont(.pretendardSemiBold, size: 14)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.top, 14)
            }
            .widgetURL(URL(string: "toduck://diary")!)
        default:
            EmptyView()
        }
    }
}

struct DiaryWidget: Widget {
    let kind: String = WidgetConstant.diary.kindIdentifier

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DiaryWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DiaryWidgetEntryView(entry: entry)
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("토덕 - To.duck")
        .description("매일 일기 쓰기 습관을 위해 휴대폰 홈 화면에 바로가기 위젯을 추가하세요!")
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    DiaryWidget()
} timeline: {
    let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let now = Date()
    DiaryEntry(date: Date(), lastWriteDate: yesterDay, count: 14)
}
