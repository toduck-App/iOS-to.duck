import Combine
import Foundation
import TDDomain

final class ToduckViewModel: BaseViewModel {
    enum Input {
        case fetchScheduleList
    }
    
    enum Output {
        case fetchedScheduleList
        case fetchedEmptyScheduleList
        case failure(error: String)
    }
    
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let shouldMarkAllDayUseCase: ShouldMarkAllDayUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var isAllDays = false
    private(set) var todaySchedules: [Schedule] = []
    private(set) var uncompletedSchedules: [Schedule] = []
    private(set) var isShowingRemaining: Bool = false
    
    var currentDisplaySchedules: [Schedule] {
        isShowingRemaining ? uncompletedSchedules : todaySchedules
    }
    var categoryImages: [TDCategoryImageType] {
        currentDisplaySchedules.map { TDCategoryImageType.init(rawValue: $0.category.imageName) }
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
            self.todaySchedules = todaySchedules.sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
            self.uncompletedSchedules = todaySchedules.filter { schedule in
                guard let records = schedule.scheduleRecords, !records.isEmpty else {
                    // 기록이 없으면 완료 안 했으므로 "남은일정"
                    return true
                }

                // 기록이 있는 경우, 오늘 날짜에 완료 안 한 게 있다면 "남은일정"
                return records.contains { record in
                    record.recordDate == schedule.startDate && !record.isComplete
                }
            }
            
            if todaySchedules.isEmpty {
                output.send(.fetchedEmptyScheduleList)
            } else {
                output.send(.fetchedScheduleList)
            }
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
    
    func switchToRemainingSchedules() {
        isShowingRemaining = true
    }

    func switchToTodaySchedules() {
        isShowingRemaining = false
    }
}
