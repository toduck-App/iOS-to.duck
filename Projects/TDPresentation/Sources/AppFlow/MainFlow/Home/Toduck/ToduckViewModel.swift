import Combine
import Foundation
import TDDomain

final class ToduckViewModel: BaseViewModel {
    enum Input {
        case fetchScheduleList
    }
    
    enum Output {
        case fetchedScheduleList
        case failure(error: String)
    }
    
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let shouldMarkAllDayUseCase: ShouldMarkAllDayUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var isAllDays = false
    private(set) var todaySchedules: [Schedule] = []
    
    var categoryImages: [TDCategoryImageType] {
        todaySchedules.map { TDCategoryImageType.init(rawValue: $0.category.imageName) }
    }
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        shouldMarkAllDayUseCase: ShouldMarkAllDayUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.shouldMarkAllDayUseCase = shouldMarkAllDayUseCase
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
            let todayFormat = Date().convertToString(formatType: .yearMonthDay)
            let todaySchedules = try await fetchScheduleListUseCase.execute(
                startDate: todayFormat,
                endDate: todayFormat
            )
            isAllDays = shouldMarkAllDayUseCase.execute(with: todaySchedules)
            self.todaySchedules = todaySchedules
            output.send(.fetchedScheduleList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
}
