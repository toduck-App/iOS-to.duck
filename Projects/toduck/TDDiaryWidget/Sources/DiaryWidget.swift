/*
 App과 AppExtension(Today Extension, Widget Extension 등)은 UserDefaults를 공유하지 않는다.
 */

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    /*
     위젯의 미리보기 상태를 설정할 수 있다.
     사용자가 위젯을 추가하기 전에 기본적으로 보이는 UI 상태를 제공한다.
     보통은 Date()로 현재 시간을 넣고, 기본 설정값을 적용한다. → 필요에 따라 커스텀
     */
    func placeholder(in context: Context) -> DiaryEntry {
        DiaryEntry(date: Date(), count: 2, isDangerous: false)
    }

    /*
     위젯 갤러리에서 스냅샷을 생성할 때 사용된다.
     보통 timeline()과 유사하지만, 빠르게 표시할 수 있는 기본 데이터를 제공한다는 특징을 가진다.
     앱에서 즉시 보여줄 수 있는 데이터를 반환하는 역할이다.
     */
    func getSnapshot(in context: Context, completion: @escaping (DiaryEntry) -> ()) {
        let entry = DiaryEntry(date: Date(), count: 3, isDangerous: false)
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
        var entries: [DiaryEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DiaryEntry(date: entryDate, count: hourOffset, isDangerous: false)
            entries.append(entry)
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
    var date: Date
    let count: Int
    let isDangerous: Bool
}

struct DiaryWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily

    func loadImage() -> Image {
        /*
         -
             - A. [0번] 일기를 한번도 작성 하지 않은 유저
                 - A1, A2, A3 디자인 시안 돌리기
             - B. [N번] 일기를 꾸준히 작성중인 유저
                 - B1, B2, B3

                     ** 예외 사항 : 과거 놓친 일기 작성시에도 작성 횟수가 올라간다.
                     단, 과거 일기 1번 / 오늘 일기 1번 등 하루에 2번 이상 일기 작성 시 횟수는 누적되지 않음

             - C. [N번, 오후 10시 이후 아직 일기를 작성하지 않았을 경우 (일기 작성 재촉 개념..)
                 - C1, C2 ,C3 디자인 시안 돌리기
                 - 토마토 아이콘 옆에 경고 뱃지 추가
             - D. [0번] 미루기 시작한 유저 (N번에서 0번이 된 상태)
                 - D1, D2, D3 디자인 시안 돌리기
         */
        TDWidgetImage.Diary.A1
    }

    func isDangerous() -> Bool {
        // 여기에 10시가 넘었는데도 일기를 작성하지 않았다면 true를 반환하도록 구현
        entry.isDangerous
    }

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack(alignment: .top) {
                loadImage()

                VStack {
                    HStack(alignment: .center, spacing: 6) {
                        TDWidgetImage.tomato
                            .frame(width: 44, height: 44)
                            .overlay(alignment: .bottomTrailing) {
                                if isDangerous() {
                                    TDWidgetImage.error
                                        .frame(width: 24, height: 24)
                                }
                            }

                        Text("\(entry.count)")
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
                .padding(.top, 10)
            }
        default:
            EmptyView()
        }
    }
}

struct DiaryWidget: Widget {
    let kind: String = "DiaryWidget"

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
    DiaryEntry(date: Date(), count: 100, isDangerous: true)
}
