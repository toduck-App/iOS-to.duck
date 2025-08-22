import Combine
import Foundation
import TDDomain

enum ScheduleSegmentType {
    case today
    case uncompleted
}

final class ToduckViewModel: BaseViewModel {
    enum Input {
        case fetchScheduleList
    }
    
    enum Output {
        case fetchedScheduleList(isEmpty: Bool)
        case failure(error: String)
    }
    
    private let fetchAllSchedulesUseCase: FetchAllSchedulesUseCase
    private let shouldMarkAllDayUseCase: ShouldMarkAllDayUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var isAllDays = false
    private(set) var currentSchedules: [Schedule] = []
    private(set) var uncompletedSchedules: [Schedule] = []
    private(set) var selectedSegment: ScheduleSegmentType = .today
    
    var currentDisplaySchedules: [Schedule] {
        switch selectedSegment {
        case .today:
            return currentSchedules
        case .uncompleted:
            return uncompletedSchedules
        }
    }
    
    var categoryImages: [TDCategoryImageType] {
        currentDisplaySchedules.map { TDCategoryImageType.init(rawValue: $0.category.imageName) }
    }
    
    init(
        fetchAllSchedulesUseCase: FetchAllSchedulesUseCase,
        shouldMarkAllDayUseCase: ShouldMarkAllDayUseCase
    ) {
        self.fetchAllSchedulesUseCase = fetchAllSchedulesUseCase
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
            let todayNormalizedDate = Date().normalized
            let todayFormat = todayNormalizedDate.convertToString(formatType: .yearMonthDay)
            
            let allSchedules = try await fetchAllSchedulesUseCase.execute(
                startDate: todayFormat,
                endDate: todayFormat
            )
            
            if let todaySchedules = allSchedules[todayNormalizedDate], !todaySchedules.isEmpty {
                isAllDays = shouldMarkAllDayUseCase.execute(with: todaySchedules)
                let sortedSchedules = todaySchedules.sorted {
                    Date.timeSortKey($0.time) < Date.timeSortKey($1.time)
                }
                
                currentSchedules = sortedSchedules
                
                uncompletedSchedules = sortedSchedules.filter { schedule in
                    if schedule.source == .localCalendar { return true }
                    
                    guard let records = schedule.scheduleRecords, !records.isEmpty else {
                        return true // 오늘 기록이 없으면 완료 안한 상태
                    }
                    
                    if let todayRecord = records.first(where: { $0.recordDate == todayFormat }) {
                        return !todayRecord.isComplete // 기록이 있다면, 완료안된 것만 포함
                    } else {
                        return true // 오늘 기록이 없으면 완료 안한 상태
                    }
                }
                
                output.send(.fetchedScheduleList(isEmpty: false))
            } else {
                currentSchedules = []
                uncompletedSchedules = []
                output.send(.fetchedScheduleList(isEmpty: true))
            }
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
    
    func setSegment(_ type: ScheduleSegmentType) {
        self.selectedSegment = type
    }
}
