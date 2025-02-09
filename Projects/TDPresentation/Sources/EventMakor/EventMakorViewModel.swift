import Combine
import Foundation
import TDCore
import TDDomain

final class EventMakorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case selectCategory(String, String)
        case selectDate(String, String)
        case selectTime(Bool, Date?)
        case saveEvent
        case updateTitleTextField(String)
        case updateLocationTextField(String)
        case updateTextView(String)
        case selectLockType(Bool)
        case selectRepeatDay(index: Int)
        case selectAlarm(index: Int)
    }
    
    enum Output {
        case fetchedCategories
        case savedEvent
    }
    
    private let mode: ScheduleAndRoutineViewController.Mode
    private let output = PassthroughSubject<Output, Never>()
    private let createScheduleUseCase: CreateScheduleUseCase
    private let createRoutineUseCase: CreateRoutineUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private var cancellables = Set<AnyCancellable>()
    private(set) var categories: [TDCategory] = []
    
    // 생성할 일정 & 루틴 정보
    private var title: String?
    private var selectedCategory: TDCategory?
    private var startDate: String? // YYYY-MM-DD
    private var endDate: String? // YYYY-MM-DD
    private var isAllDay: Bool = false
    private var time: Date? // hh:mm
    private var isPublic: Bool = true
    private var repeatDays: [TDWeekDay]?
    private var alarms: [AlarmType]?
    private var location: String?
    private var memo: String?
    
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        createScheduleUseCase: CreateScheduleUseCase,
        createRoutineUseCase: CreateRoutineUseCase,
        fetchCategoriesUseCase: FetchCategoriesUseCase
    ) {
        self.mode = mode
        self.createScheduleUseCase = createScheduleUseCase
        self.createRoutineUseCase = createRoutineUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            self?.handleInput(event)
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private func handleInput(_ event: Input) {
        switch event {
        case .fetchCategories:
            Task { await fetchCategories() }
        case .selectCategory(let colorHex, let imageName):
            selectedCategory = TDCategory(colorHex: colorHex, imageName: imageName)
        case .selectDate(let startDay, let endDay):
            startDate = startDay
            endDate = endDay
        case .selectTime(let isAllDay, let time):
            self.isAllDay = isAllDay
            self.time = time
        case .selectLockType(let isPublic):
            self.isPublic = isPublic
        case .saveEvent:
            saveEvent()
        case .updateTitleTextField(let title):
            self.title = title
        case .updateLocationTextField(let location):
            self.location = location
        case .updateTextView(let memo):
            self.memo = memo
        case .selectRepeatDay(let index):
            handleRepeatDaySelection(at: index)
        case .selectAlarm(let index):
            handleAlarmSelection(at: index)
        }
    }
    
    private func saveEvent() {
        if mode == .schedule {
            Task { await saveSchedule() }
        } else {
            Task { await saveRoutine() }
        }
    }
    
    private func saveSchedule() async {
        guard validateScheduleInputs() else { return }
        do {
            let schedule = createSchedule()
            try await createScheduleUseCase.execute(schedule: schedule)
            TDLogger.info("일정 생성 성공: \(schedule)")
            output.send(.savedEvent)
        } catch {
            TDLogger.error("일정 생성 실패: \(error)")
        }
    }
    
    // MARK: - Create Schedule & Routine
    private func saveRoutine() async {
        guard validateRoutineInputs() else { return }
        do {
            let routine = createRoutine()
            try await createRoutineUseCase.execute(routine: routine)
            TDLogger.info("루틴 생성 성공: \(routine)")
            output.send(.savedEvent)
        } catch {
            TDLogger.error("루틴 생성 실패: \(error)")
        }
    }

    private func validateScheduleInputs() -> Bool {
        guard let title, let selectedCategory, let startDate, let endDate else {
            TDLogger.error("필수 값 누락: \(title), \(selectedCategory), \(startDate), \(endDate)")
            return false
        }
        return true
    }

    private func validateRoutineInputs() -> Bool {
        guard let title, let selectedCategory else {
            TDLogger.error("필수 값 누락: \(title), \(selectedCategory)")
            return false
        }
        return true
    }

    // MARK: - Object Creation
    private func createSchedule() -> Schedule {
        Schedule(
            id: nil,
            title: title!,
            category: selectedCategory!,
            startDate: startDate!,
            endDate: endDate!,
            isAllDay: isAllDay,
            time: time,
            repeatDays: repeatDays,
            alarmTimes: alarms,
            place: location,
            memo: memo,
            isFinished: false
        )
    }

    private func createRoutine() -> Routine {
        Routine(
            id: nil,
            title: title!,
            category: selectedCategory!,
            isAllDay: isAllDay,
            isPublic: isPublic,
            date: nil,
            time: time,
            repeatDays: repeatDays,
            alarmTimes: alarms,
            memo: memo,
            recommendedRoutines: nil,
            isFinished: false
        )
    }
    
    // MARK: - Fetch 카테고리 목록
    private func fetchCategories() async {
        do {
            let categories = try await fetchCategoriesUseCase.execute()
            self.categories = categories
            output.send(.fetchedCategories)
        } catch {
            // TODO: Handle error
            TDLogger.error(error)
        }
    }
    
    // MARK: - 반복 날짜와 알람에 대한 설정
    private func handleRepeatDaySelection(at index: Int) {
        let repeatDaysArray: [TDWeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        
        guard index >= 0, index < repeatDaysArray.count else {
            TDLogger.error("Invalid repeat day index: \(index)")
            return
        }
        
        let selectedDay = repeatDaysArray[index]
        if repeatDays == nil {
            repeatDays = []
        }
        
        if let existingIndex = repeatDays?.firstIndex(of: selectedDay) {
            repeatDays?.remove(at: existingIndex) // 이미 선택된 경우 제거 (토글 기능)
        } else {
            repeatDays?.append(selectedDay) // 선택 추가
        }
        
        TDLogger.info("현재 반복 요일: \(repeatDays ?? [])")
    }

    private func handleAlarmSelection(at index: Int) {
        let alarmTypesArray: [AlarmType] = [.tenMinutesBefore, .thirtyMinutesBefore, .oneHourBefore]
        
        guard index >= 0, index < alarmTypesArray.count else {
            TDLogger.error("Invalid alarm index: \(index)")
            return
        }
        
        let selectedAlarm = alarmTypesArray[index]
        if alarms == nil {
            alarms = []
        }
        
        if let existingIndex = alarms?.firstIndex(of: selectedAlarm) {
            alarms?.remove(at: existingIndex) // 이미 선택된 경우 제거 (토글 기능)
        } else {
            alarms?.append(selectedAlarm) // 선택 추가
        }
        
        TDLogger.info("현재 알람: \(alarms ?? [])")
    }
}
