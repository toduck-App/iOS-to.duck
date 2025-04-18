import Combine
import Foundation
import TDDomain

final class ToduckCalendarViewModel: BaseViewModel {
    enum Input {
        case fetchSchedule(startDate: String, endDate: String, isMonth: Bool)
        case checkBoxTapped(Schedule)
    }
    
    enum Output {
        case fetchedScheduleList
        case successFinishSchedule
        case failure(error: String)
    }
    
    // MARK: - Properties
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let buildMonthScheduleDictUseCase: BuildMonthScheduleDictUseCase
    private let finishScheduleUseCase: FinishScheduleUseCase
    private let finishRoutineUseCase: FinishRoutineUseCase
    private let output = PassthroughSubject<Output, Never>()
    private(set) var monthScheduleDict: [Date: [Schedule]] = [:]
    private(set) var currentDayScheduleList: [Schedule] = []
    private var cancellables = Set<AnyCancellable>()
    var selectedDate: Date?
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        buildMonthScheduleDictUseCase: BuildMonthScheduleDictUseCase,
        finishScheduleUseCase: FinishScheduleUseCase,
        finishRoutineUseCase: FinishRoutineUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.buildMonthScheduleDictUseCase = buildMonthScheduleDictUseCase
        self.finishScheduleUseCase = finishScheduleUseCase
        self.finishRoutineUseCase = finishRoutineUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchSchedule(let startDate, let endDate, let isMonth):
                Task { await self?.fetchScheduleList(startDate: startDate, endDate: endDate, isMonth: isMonth) }
            case .checkBoxTapped(let schedule):
                Task { await self?.finishSchedule(with: schedule) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    // TODO: buildMonthScheduleDictUseCase를 fetchScheduleListUseCase 구현체에 합치도록 리팩토링하기
    private func fetchScheduleList(startDate: String, endDate: String, isMonth: Bool) async {
        do {
            let fetchedSchedule = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            if isMonth,
               let monthStart = Date.convertFromString(startDate, format: .yearMonthDay),
               let monthEnd = Date.convertFromString(endDate, format: .yearMonthDay) {
                let monthScheduleDict = buildMonthScheduleDictUseCase.execute(schedules: fetchedSchedule, monthStart: monthStart, monthEnd: monthEnd)
                self.monthScheduleDict = monthScheduleDict
            } else {
                self.currentDayScheduleList = fetchedSchedule.sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
            }
            
            output.send(.fetchedScheduleList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
    
    private func finishSchedule(with schedule: Schedule) async {
        do {
            try await finishScheduleUseCase.execute(
                scheduleId: schedule.id ?? 0,
                isComplete: !schedule.isFinished,
                queryDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? ""
            )
            output.send(.successFinishSchedule)
        } catch {
            output.send(.failure(error: "일정을 완료할 수 없습니다."))
        }
    }
}
