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
    
    init(
    ) {
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}

extension RoutineViewModel: TimeSlotProvider {
    var timeSlots: [TimeSlot] {
        return []
    }
    
    func convertEventToDisplayItem(
        event: EventPresentable
    ) -> EventDisplayItem {
        guard let routine = event as? Routine else { return EventDisplayItem(from: event) }
        
        return EventDisplayItem(
            from: event,
            alarmTime: routine.alarmTime?.rawValue,
            date: nil, // TODO: 일정 등록 날짜 추가
            repeatDays: routine.repeatDays?.map { $0.title }.joined(separator: ", "),
            place: nil,
            isPublic: routine.isPublic
        )
    }
}
