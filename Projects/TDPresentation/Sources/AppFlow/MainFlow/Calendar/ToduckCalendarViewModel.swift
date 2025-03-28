import Combine
import Foundation

import TDDomain

final class ToduckCalendarViewModel: BaseViewModel {
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
    private(set) var scheduleList: [Schedule] = []
    private var cancellables = Set<AnyCancellable>()
    
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
