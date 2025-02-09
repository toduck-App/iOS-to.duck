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
    func convertEventToDisplayItem(event: EventPresentable) -> EventDisplayItem {
        guard let schedule = event as? Schedule,
              let place = schedule.place else { return EventDisplayItem(from: event) }
        let eventDisplayItem = EventDisplayItem(from: event)
        return eventDisplayItem.configurePlace(place)
    }
    
    var timeSlots: [TimeSlot] {
        return []
    }
}
