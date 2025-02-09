import Combine
import Foundation
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
    func convertEventToDisplayItem(
        event: EventPresentable
    ) -> EventDisplayItem {
        guard let schedule = event as? Schedule,
              let place = schedule.place else { return EventDisplayItem(from: event) }
        let eventDisplayItem = EventDisplayItem(from: event)
        return eventDisplayItem.configurePlace(place)
    }
    
    var timeSlots: [TimeSlot] {
        return [TimeSlot(
            timeText: "10:00",
            events: [Schedule(
                id: 0,
                title: "1번 일정",
                category: TDCategory(colorHex: "#123456", imageName: "power"),
                startDate: "2021-09-01",
                endDate: "2022-10-10",
                isAllDay: false,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: "장소1",
                memo: "메모1",
                isFinished: false
            ), Schedule(
                id: 0,
                title: "2번 일정",
                category: TDCategory(colorHex: "#FFE3CC", imageName: "sleep"),
                startDate: "2021-09-01",
                endDate: "2022-10-10",
                isAllDay: false,
                time: Date(),
                repeatDays: nil,
                alarmTimes: nil,
                place: "장소2",
                memo: "메모2",
                isFinished: false
            )]
        ), TimeSlot(
            timeText: "12:00",
            events: [Schedule(
                id: 0,
                title: "3번 일정",
                category: TDCategory(colorHex: "#555555", imageName: "power"),
                startDate: "2021-09-01",
                endDate: "2022-10-10",
                isAllDay: false,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: "장소1",
                memo: "메모1",
                isFinished: false
            ), Schedule(
                id: 0,
                title: "4번 일정",
                category: TDCategory(colorHex: "#444444", imageName: "sleep"),
                startDate: "2021-09-01",
                endDate: "2022-10-10",
                isAllDay: false,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: "장소2",
                memo: "메모2",
                isFinished: true
            )]
        )]
    }
}
