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
    private(set) var selectedSegment: ScheduleSegmentType = .today
    
    var currentDisplaySchedules: [Schedule] {
        switch selectedSegment {
        case .today:
            return todaySchedules
        case .uncompleted:
            return uncompletedSchedules
        }
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
//        do {
//            let todayFormat = Date().convertToString(formatType: .yearMonthDay)
//            let fetchedTodaySchedules = try await fetchScheduleListUseCase.execute(
//                startDate: todayFormat,
//                endDate: todayFormat
//            )
//            isAllDays = shouldMarkAllDayUseCase.execute(with: fetchedTodaySchedules)
//            todaySchedules = fetchedTodaySchedules.sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
//
//            // 오늘 날짜에 완료 안 한 일정만 필터링
//            uncompletedSchedules = fetchedTodaySchedules
//                .filter { schedule in
//                    guard let records = schedule.scheduleRecords, !records.isEmpty else {
//                        return true // 오늘 기록이 없으면 완료 안한 상태
//                    }
//                    
//                    if let todayRecord = records.first(where: { $0.recordDate == todayFormat }) {
//                        return !todayRecord.isComplete // 기록이 있다면, 완료안된 것만 포함
//                    } else {
//                        return true // 오늘 기록이 없으면 완료 안한 상태
//                    }
//                }
//                .sorted {
//                    Date.timeSortKey($0.time) < Date.timeSortKey($1.time)
//                }
//
//            if fetchedTodaySchedules.isEmpty {
//                output.send(.fetchedEmptyScheduleList)
//            } else {
//                output.send(.fetchedScheduleList)
//            }
//        } catch {
//            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
//        }
    }
    
    func setSegment(_ type: ScheduleSegmentType) {
        self.selectedSegment = type
    }
}
