import Combine
import Foundation
import TDDomain

final class RoutineViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var routines: [Routine] = []
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}

extension RoutineViewModel: TimeSlotProvider {
    var timeSlots: [TimeSlot] {
        return [TimeSlot(timeText: "10:00", events: Routine.dummy)]
    }
    
    func convertEventToDisplayItem(
        event: EventPresentable
    ) -> EventDisplayItem {
        guard let routine = event as? Routine else { return EventDisplayItem(from: event) }
        
        return EventDisplayItem(
            from: event,
            alarmTimes: routine.alarmTimes?.map { $0.title },
            date: nil, // TODO: 일정 등록 날짜 추가
            repeatDays: routine.repeatDays?.map { $0.title }.joined(separator: ", "),
            place: nil,
            isPublic: routine.isPublic
        )
    }
}
