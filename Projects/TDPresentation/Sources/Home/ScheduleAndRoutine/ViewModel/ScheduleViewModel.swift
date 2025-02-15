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
        return [TimeSlot(
            timeText: "10:00",
            events: Schedule.dummy
        ), TimeSlot(
            timeText: "12:00",
            events: Schedule.dummy
        )]
    }
    
    func convertEventToDisplayItem(
        event: EventPresentable
    ) -> EventDisplayItem {
        guard let schedule = event as? Schedule,
              let place = schedule.place else { return EventDisplayItem(from: event) }
        return EventDisplayItem(from: event, place: place)
    }
}
