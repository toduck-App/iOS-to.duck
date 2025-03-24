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
    var timeSlots: [TimeSlot] {
        return []
    }
    
    func convertEventToDisplayItem(
        event: EventPresentable
    ) -> EventDisplayItem {
        guard let schedule = event as? Schedule else { return EventDisplayItem(from: event) }
        
        return EventDisplayItem(
            from: event,
            alarmTime: schedule.alarmTime?.rawValue,
            date: nil, // TODO: 일정 등록 날짜 추가
            repeatDays: schedule.repeatDays?.map { $0.title }.joined(separator: ", "),
            place: schedule.place,
            isPublic: false
        )
    }
}
