import Combine
import Foundation
import TDDomain

final class ToduckCalendarViewModel: BaseViewModel {
    enum Input {
        case fetchSchedule(startDate: String, endDate: String)
        case fetchDetailSchedule(date: Date)
        case deleteTodayTodo(scheduleId: Int)
        case deleteAllTodo(scheduleId: Int)
        case checkBoxTapped(Schedule)
    }
    
    enum Output {
        case fetchedScheduleList
        case fetchedDetailSchedule
        case successFinishSchedule
        case deletedTodo
        case failure(error: String)
    }
    
    // MARK: - Properties
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let finishScheduleUseCase: FinishScheduleUseCase
    private let deleteScheduleUseCase: DeleteScheduleUseCase
    private let output = PassthroughSubject<Output, Never>()
    private(set) var monthScheduleDict: [Date: [Schedule]] = [:]
    private(set) var currentDayScheduleList: [Schedule] = []
    private var cancellables = Set<AnyCancellable>()
    var selectedDate = Date()
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        finishScheduleUseCase: FinishScheduleUseCase,
        deleteScheduleUseCase: DeleteScheduleUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.finishScheduleUseCase = finishScheduleUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        let shared = input.share()

        shared
            .filter { event in
                if case .checkBoxTapped = event {
                    return false
                }
                return true
            }
            .sink { [weak self] event in
            switch event {
            case .fetchSchedule(let startDate, let endDate):
                Task { await self?.fetchScheduleList(startDate: startDate, endDate: endDate) }
            case .fetchDetailSchedule(let date):
                let key = Calendar.current.startOfDay(for: date)
                let scheduleList = self?.monthScheduleDict[key] ?? []
                self?.currentDayScheduleList = scheduleList.sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
                self?.output.send(.fetchedDetailSchedule)
            case .deleteTodayTodo(let scheduleId):
                Task { await self?.deleteSchedule(scheduleId: scheduleId, isOneDayDeleted: true) }
            case .deleteAllTodo(let scheduleId):
                Task { await self?.deleteSchedule(scheduleId: scheduleId, isOneDayDeleted: false) }
            default:
                break
            }
        }.store(in: &cancellables)
        
        shared
            .filter { event in
                if case .checkBoxTapped = event {
                    return true
                }
                return false
            }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] event in
                if case .checkBoxTapped(let schedule) = event {
                    Task { await self?.finishSchedule(with: schedule) }
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchScheduleList(startDate: String, endDate: String) async {
        do {
            let fetchedSchedule = try await fetchScheduleListUseCase.execute(startDate: startDate, endDate: endDate)
            self.monthScheduleDict = fetchedSchedule
            
            let key = Calendar.current.startOfDay(for: selectedDate)
            let scheduleList = monthScheduleDict[key] ?? []
            self.currentDayScheduleList = scheduleList.sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
            
            output.send(.fetchedScheduleList)
        } catch {
            output.send(.failure(error: "일정을 불러오는데 실패했습니다."))
        }
    }
    
    private func finishSchedule(with schedule: Schedule) async {
        do {
            let toggledFinished = !schedule.isFinished
            let key = Calendar.current.startOfDay(for: selectedDate)

            try await finishScheduleUseCase.execute(
                scheduleId: schedule.id ?? 0,
                isComplete: toggledFinished,
                queryDate: selectedDate.convertToString(formatType: .yearMonthDay)
            )

            if var schedules = monthScheduleDict[key] {
                if let index = schedules.firstIndex(where: { $0.id == schedule.id }) {
                    var updatedSchedule = schedules[index]
                    updatedSchedule = Schedule(
                        id: updatedSchedule.id,
                        title: updatedSchedule.title,
                        category: updatedSchedule.category,
                        startDate: updatedSchedule.startDate,
                        endDate: updatedSchedule.endDate,
                        isAllDay: updatedSchedule.isAllDay,
                        time: updatedSchedule.time,
                        repeatDays: updatedSchedule.repeatDays,
                        alarmTime: updatedSchedule.alarmTime,
                        place: updatedSchedule.place,
                        memo: updatedSchedule.memo,
                        isFinished: toggledFinished,
                        scheduleRecords: updatedSchedule.scheduleRecords
                    )
                    schedules[index] = updatedSchedule
                    monthScheduleDict[key] = schedules
                }
            }

            if let index = currentDayScheduleList.firstIndex(where: { $0.id == schedule.id }) {
                var updated = currentDayScheduleList[index]
                updated = Schedule(
                    id: updated.id,
                    title: updated.title,
                    category: updated.category,
                    startDate: updated.startDate,
                    endDate: updated.endDate,
                    isAllDay: updated.isAllDay,
                    time: updated.time,
                    repeatDays: updated.repeatDays,
                    alarmTime: updated.alarmTime,
                    place: updated.place,
                    memo: updated.memo,
                    isFinished: toggledFinished,
                    scheduleRecords: updated.scheduleRecords
                )
                currentDayScheduleList[index] = updated
            }

            output.send(.successFinishSchedule)
        } catch {
            output.send(.failure(error: "일정을 완료할 수 없습니다."))
        }
    }
    
    // MARK: - 투두 삭제
    private func deleteSchedule(scheduleId: Int, isOneDayDeleted: Bool) async {
        do {
            try await deleteScheduleUseCase.execute(
                scheduleId: scheduleId,
                isOneDayDeleted: isOneDayDeleted,
                queryDate: selectedDate.convertToString(formatType: .yearMonthDay)
            )
            output.send(.deletedTodo)
        } catch {
            output.send(.failure(error: "일정을 삭제할 수 없습니다."))
        }
    }
}
