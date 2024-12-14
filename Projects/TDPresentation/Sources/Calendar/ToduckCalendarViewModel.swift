import Combine
import Foundation

import TDDomain

final class ToduckCalendarViewModel {
    enum Input {
        case fetchScheduleList
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
            case .fetchScheduleList:
                Task { await self?.fetchScheduleList() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchScheduleList() async {
        do {
            let scheduleList = try await fetchScheduleListUseCase.execute()
            self.scheduleList = scheduleList
            output.send(.fetchedScheduleList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
}
