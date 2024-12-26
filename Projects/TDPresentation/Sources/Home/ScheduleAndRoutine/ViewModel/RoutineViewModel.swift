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
        return [TimeSlot(timeText: "9 AM", events: [Routine(id: UUID(), title: "루틴 1", category: TDCategory(colorType: .back1, imageType: .computer), isAllDay: false, isPublic: true, date: Date(), time: nil, repeatDays: nil, alarmTimes: nil, memo: nil, recommendedRoutines: nil, isFinish: false)])]
    }
}
