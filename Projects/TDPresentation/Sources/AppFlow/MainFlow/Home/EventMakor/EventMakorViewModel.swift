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
        case tapScheduleEditTodayButton
        case tapScheduleEditAllButton
        case tapEditRoutineButton
        case tapSaveTodoButton
        case updateTitleTextField(String)
        case updateLocationTextField(String)
        case updateMemoTextView(String)
        case selectLockType(Bool)
        case selectRepeatDay(index: Int, isSelected: Bool)
        case selectAlarm(index: Int, isSelected: Bool)
    }
    
    enum Output {
        case fetchedCategories
        case savedEvent
        case failedToSaveEvent(missingFields: [String])
        case failureAPI(String)
    }
    
    private let mode: EventMakorViewController.Mode
    private let output = PassthroughSubject<Output, Never>()
    private let createScheduleUseCase: CreateScheduleUseCase
    private let createRoutineUseCase: CreateRoutineUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private let updateScheduleUseCase: UpdateScheduleUseCase
    private var cancellables = Set<AnyCancellable>()
    private(set) var categories: [TDCategory] = []
    private let preEvent: (any EventPresentable)?
    
    // 생성할 일정 & 루틴 정보
    private var title: String?
    private var selectedCategory: TDCategory? = TDCategory(colorHex: "#FFFFFF", imageName: "None")
    private var startDate: String? // YYYY-MM-DD
    private var endDate: String? // YYYY-MM-DD
    private var isAllDay: Bool = true
    private var time: Date? // hh:mm
    private var isPublic: Bool = true
    private var repeatDays: [TDWeekDay]?
    private var alarm: AlarmType?
    private var location: String?
    private var memo: String?
    
    // 수정에 필요한 정보
    private let selectedDate: Date?
    private var isOneDayDeleted: Bool = false
    
    init(
        mode: EventMakorViewController.Mode,
        createScheduleUseCase: CreateScheduleUseCase,
        createRoutineUseCase: CreateRoutineUseCase,
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        updateScheduleUseCase: UpdateScheduleUseCase,
        preEvent: (any EventPresentable)?,
        selectedDate: Date? = nil
    ) {
        self.mode = mode
        self.createScheduleUseCase = createScheduleUseCase
        self.createRoutineUseCase = createRoutineUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.updateScheduleUseCase = updateScheduleUseCase
        self.preEvent = preEvent
        self.selectedDate = selectedDate
        initialValueSetup()
    }
    
    private func initialValueSetup() {
        // TODO: preEvent가 nil이 아닐 때, preEvent의 정보로 초기화
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            self?.handleInput(event)
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func setupInitialDate(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let initialDate = dateFormatter.string(from: date)
        startDate = initialDate
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
        case .tapScheduleEditTodayButton:
            self.isOneDayDeleted = true
            Task { await self.updateSchedule() }
        case .tapScheduleEditAllButton:
            self.isOneDayDeleted = false
            Task { await self.updateSchedule() }
        case .tapEditRoutineButton:
            self.updateRoutine()
        case .tapSaveTodoButton:
            saveEvent()
        case .updateTitleTextField(let title):
            self.title = title
        case .updateLocationTextField(let location):
            self.location = location
        case .updateMemoTextView(let memo):
            self.memo = memo
        case .selectRepeatDay(let index, let isSelected):
            handleRepeatDaySelection(at: index, isSelected: isSelected)
        case .selectAlarm(let index, let isSelected):
            handleAlarmSelection(at: index, isSelected: isSelected)
        }
    }
    
    private func updateSchedule() async {
        do {
            guard let scheduleId = preEvent?.id else { return }
            try await updateScheduleUseCase.execute(
                scheduleId: scheduleId,
                isOneDayDeleted: isOneDayDeleted,
                queryDate: selectedDate?.convertToString(formatType: .yearMonthDay) ?? "",
                scheduleData: createSchedule()
            )
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func updateRoutine() {
        
    }
    
    private func saveEvent() {
        if mode == .schedule {
            Task { await saveSchedule() }
        } else {
            Task { await saveRoutine() }
        }
    }
    
    private func saveSchedule() async {
        let missingFields = validateScheduleInputs()
        guard missingFields.isEmpty else {
            output.send(.failedToSaveEvent(missingFields: missingFields))
            return
        }
        do {
            let schedule = createSchedule()
            try await createScheduleUseCase.execute(schedule: schedule)
            TDLogger.info("일정 생성 성공: \(schedule)")
            output.send(.savedEvent)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    // MARK: - Create Schedule & Routine
    private func saveRoutine() async {
        let missingFields = validateRoutineInputs()
        guard missingFields.isEmpty else {
            output.send(.failedToSaveEvent(missingFields: missingFields))
            return
        }
        do {
            let routine = createRoutine()
            try await createRoutineUseCase.execute(routine: routine)
            TDLogger.info("루틴 생성 성공: \(routine)")
            output.send(.savedEvent)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func validateScheduleInputs() -> [String] {
        var missingFields: [String] = []
        if title == nil { missingFields.append("title") }
        if selectedCategory == nil { missingFields.append("category") }
        if startDate == nil { missingFields.append("startDate") }
        return missingFields
    }
    
    private func validateRoutineInputs() -> [String] {
        var missingFields: [String] = []
        if title == nil { missingFields.append("title") }
        if selectedCategory == nil { missingFields.append("category") }
        return missingFields
    }
    
    // MARK: - Object Creation
    private func createSchedule() -> Schedule {
        if endDate == nil {
            endDate = startDate
        }
        
        let schedule = Schedule(
            id: nil,
            title: title!,
            category: selectedCategory!,
            startDate: startDate!,
            endDate: endDate!,
            isAllDay: isAllDay,
            time: time,
            repeatDays: repeatDays,
            alarmTime: alarm,
            place: location,
            memo: memo,
            isFinished: false,
            scheduleRecords: nil
        )
        
        return schedule
    }
    
    private func createRoutine() -> Routine {
        Routine(
            id: nil,
            title: title!,
            category: selectedCategory!,
            isAllDay: isAllDay,
            isPublic: isPublic,
            time: time,
            repeatDays: repeatDays,
            alarmTime: alarm,
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
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    // MARK: - 반복 날짜와 알람에 대한 설정
    private func handleRepeatDaySelection(at index: Int, isSelected: Bool) {
        let repeatDaysArray: [TDWeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        
        guard index >= 0, index < repeatDaysArray.count else {
            TDLogger.error("Invalid repeat day index: \(index)")
            return
        }
        
        let selectedDay = repeatDaysArray[index]
        if repeatDays == nil {
            repeatDays = []
        }
        
        if isSelected {
            // 선택 추가
            if repeatDays?.contains(selectedDay) == false {
                repeatDays?.append(selectedDay)
            }
        } else {
            // 선택 해제
            repeatDays?.removeAll(where: { $0 == selectedDay })
        }
        
        TDLogger.info("현재 반복 요일: \(repeatDays ?? [])")
    }
    
    private func handleAlarmSelection(at index: Int, isSelected: Bool) {
        let alarmTypesArray: [AlarmType] = [.tenMinutesBefore, .thirtyMinutesBefore, .oneHourBefore]
        
        guard index >= 0, index < alarmTypesArray.count else {
            TDLogger.error("Invalid alarm index: \(index)")
            return
        }
        
        let selectedAlarm = alarmTypesArray[index]
        
        if isSelected {
            // 선택한 알람 설정
            alarm = selectedAlarm
            TDLogger.info("알람 선택됨: \(selectedAlarm)")
        } else {
            // 다시 눌러서 해제한 경우
            alarm = nil
            TDLogger.info("알람 해제됨")
        }
    }
}
