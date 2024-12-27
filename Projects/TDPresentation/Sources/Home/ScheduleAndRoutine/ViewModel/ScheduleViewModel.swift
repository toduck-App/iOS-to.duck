import Combine
import TDDomain

final class ScheduleViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}

extension ScheduleViewModel: TimeSlotProvider {
    var timeSlots: [TimeSlot] {
        return [TimeSlot(timeText: "8 AM", events: [
            Schedule(
                title: "캐릭터 디자인 작업",
                category: TDCategory(colorType: .back1, imageType: .computer),
                isAllDay: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinish: false
            ),
            Schedule(
                title: "토익 공부",
                category: TDCategory(colorType: .back2, imageType: .food),
                isAllDay: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinish: true
            ),
            Schedule(
                title: "영화 보기",
                category: TDCategory(colorType: .back3, imageType: .medicine),
                isAllDay: true,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: "경북 구미시",
                memo: nil,
                isFinish: false
            )
        ]),
        TimeSlot(timeText: "12 AM", events: [
            Schedule(
                title: "점심",
                category: TDCategory(colorType: .back1, imageType: .computer),
                isAllDay: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinish: false
            ),
            Schedule(
                title: "영화 보기",
                category: TDCategory(colorType: .back14, imageType: .sleep),
                isAllDay: true,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: "경북 구미시",
                memo: nil,
                isFinish: false
            )]),
                TimeSlot(timeText: "3 PM", events: [
                    Schedule(
                        title: "가나다라마바",
                        category: TDCategory(colorType: .back4, imageType: .none),
                        isAllDay: false,
                        date: nil,
                        time: nil,
                        repeatDays: nil,
                        alarmTimes: nil,
                        place: nil,
                        memo: nil,
                        isFinish: false
                    ),
                    Schedule(
                        title: "영화 보기",
                        category: TDCategory(colorType: .back6, imageType: .redBook),
                        isAllDay: true,
                        date: nil,
                        time: nil,
                        repeatDays: nil,
                        alarmTimes: nil,
                        place: "경북 구미시",
                        memo: nil,
                        isFinish: false
                    )])
        ]
    }
}
