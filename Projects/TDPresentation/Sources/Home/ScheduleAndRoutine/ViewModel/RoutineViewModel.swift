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
    func convertEventToDisplayItem(event: EventPresentable) -> EventDisplayItem {
        return EventDisplayItem(from: event)
    }
    
    var timeSlots: [TimeSlot] {
        return []
    }
}
