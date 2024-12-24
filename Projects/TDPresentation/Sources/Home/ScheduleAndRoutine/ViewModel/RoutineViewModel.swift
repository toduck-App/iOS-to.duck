import Combine
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
        return routines.reduce(into: [String: [Routine]]()) { result, routine in
            let key = routine.time ?? "All Day"
            result[key, default: []].append(routine)
        }
        .map { key, events in
            TimeSlot(timeText: key, events: events)
        }
    }
}
