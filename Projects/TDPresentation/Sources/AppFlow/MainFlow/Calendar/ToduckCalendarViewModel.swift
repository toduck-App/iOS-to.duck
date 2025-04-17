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
    private let finishScheduleUseCase: FinishScheduleUseCase
    private let finishRoutineUseCase: FinishRoutineUseCase
    private let output = PassthroughSubject<Output, Never>()
    private(set) var monthScheduleList: [Schedule] = []
    private(set) var currentDayScheduleList: [Schedule] = []
    private var cancellables = Set<AnyCancellable>()
    var selectedDate: Date?
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        finishScheduleUseCase: FinishScheduleUseCase,
        finishRoutineUseCase: FinishRoutineUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
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
    
    private func fetchScheduleList(startDate: String, endDate: String, isMonth: Bool) async {
        do {
            let fetchedSchedule = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            
            if isMonth {
                monthScheduleList = fetchedSchedule
            } else {
                currentDayScheduleList = fetchedSchedule
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
