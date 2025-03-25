import Combine
import Foundation
import TDDomain

final class ScheduleViewModel: BaseViewModel {
    enum Input {
        case fetchScheduleList(startDate: String, endDate: String)
    }
    
    enum Output {
        case fetchedScheduleList
        case failure(error: String)
    }
    
    // MARK: - Properties
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var scheduleList: [Schedule] = []
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchScheduleList(let startDate, let endDate):
                Task { await self?.fetchScheduleList(startDate: startDate, endDate: endDate) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchScheduleList(startDate: String, endDate: String) async {
        do {
            let scheduleList = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            self.scheduleList = scheduleList
            output.send(.fetchedScheduleList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
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
