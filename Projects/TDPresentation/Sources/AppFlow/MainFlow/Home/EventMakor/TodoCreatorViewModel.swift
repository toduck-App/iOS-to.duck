import Combine
import Foundation
import TDCore
import TDDomain

final class TodoCreatorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case selectCategory(String, String)
        case selectDate(String, String)
        case selectTime(Bool, String?)
        case tapScheduleEditTodayButton
        case tapScheduleEditAllButton
        case tapEditRoutineButton
        case tapSaveTodoButton
        case updateTitleTextField(String)
        case updateLocationTextField(String)
        case updateMemoTextView(String)
        case selectLockType(Bool)
        case selectRepeatDay(index: Int, isSelected: Bool)
        case selectAlarm(title: String, isSelected: Bool)
    }
    
    enum Output {
        case fetchedCategories
        case savedEvent
        case canSaveEvent(Bool)
        case failedToSaveEvent(missingFields: [String])
        case failureAPI(String)
    }
    
    private let mode: TDTodoMode
    private let output = PassthroughSubject<Output, Never>()
    private let createScheduleUseCase: CreateScheduleUseCase
    private let createRoutineUseCase: CreateRoutineUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private let updateScheduleUseCase: UpdateScheduleUseCase
    private let updateRoutineUseCase: UpdateRoutineUseCase
    private var cancellables = Set<AnyCancellable>()
    private(set) var categories: [TDCategory] = []
    let preEvent: (any TodoItem)?
    
    // 생성할 일정 & 루틴 정보
    private var title: String?
    private var selectedCategory: TDCategory? = TDCategory(colorHex: "#FFFFFF", imageName: "None")
    private var startDate: String? // YYYY-MM-DD
    private var endDate: String? // YYYY-MM-DD
    private var isAllDay: Bool?
    private var time: String? // hh:mm
    private var isPublic: Bool = true
    private var repeatDays: [TDWeekDay]?
    private var alarm: AlarmTime?
    private var location: String?
    private var memo: String?
    
    // 수정에 필요한 정보
    private let selectedDate: Date?
    private var isOneDayDeleted: Bool = false
    
    // MARK: - Initializer
    init(
        mode: TDTodoMode,
        createScheduleUseCase: CreateScheduleUseCase,
        createRoutineUseCase: CreateRoutineUseCase,
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        updateScheduleUseCase: UpdateScheduleUseCase,
        updateRoutineUseCase: UpdateRoutineUseCase,
        preEvent: (any TodoItem)?,
        selectedDate: Date? = nil
    ) {
        self.mode = mode
        self.createScheduleUseCase = createScheduleUseCase
        self.createRoutineUseCase = createRoutineUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.updateScheduleUseCase = updateScheduleUseCase
        self.updateRoutineUseCase = updateRoutineUseCase
        self.preEvent = preEvent
        self.selectedDate = selectedDate
        initialValueSetupForEditMode()
    }
    
    private func initialValueSetupForEditMode() {
        guard let preEvent else { return }
        
        if let schedule = preEvent as? Schedule {
            self.title = schedule.title
            self.selectedCategory = schedule.category
            self.startDate = schedule.startDate
            self.endDate = schedule.endDate
            self.isAllDay = schedule.isAllDay
            self.time = schedule.time
            self.repeatDays = schedule.repeatDays
            self.alarm = schedule.alarmTime
            self.location = schedule.place
            self.memo = schedule.memo
        } else if let routine = preEvent as? Routine {
            self.title = routine.title
            self.selectedCategory = routine.category
            self.isAllDay = routine.isAllDay
            self.time = routine.time
            self.isPublic = routine.isPublic
            self.repeatDays = routine.repeatDays
            self.alarm = routine.alarmTime
            self.memo = routine.memo
        }
    }
    
    // MARK: - Input / Output
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                switch event {
                case .fetchCategories:
                    Task { await self?.fetchCategories() }
                case .selectCategory(let colorHex, let imageName):
                    self?.selectedCategory = TDCategory(colorHex: colorHex, imageName: imageName)
                case .selectDate(let startDay, let endDay):
                    self?.startDate = startDay
                    self?.endDate = endDay
                case .selectTime(let isAllDay, let time):
                    self?.isAllDay = isAllDay
                    self?.time = time
                    self?.validateCanSave()
                case .selectLockType(let isPublic):
                    self?.isPublic = isPublic
                case .tapScheduleEditTodayButton:
                    self?.isOneDayDeleted = true
                    Task { await self?.updateSchedule() }
                case .tapScheduleEditAllButton:
                    self?.isOneDayDeleted = false
                    Task { await self?.updateSchedule() }
                case .tapEditRoutineButton:
                    Task { await self?.updateRoutine() }
                case .updateTitleTextField(let title):
                    self?.title = title
                    self?.validateCanSave()
                case .updateLocationTextField(let location):
                    self?.location = location
                case .updateMemoTextView(let memo):
                    self?.memo = memo
                case .selectRepeatDay(let index, let isSelected):
                    self?.handleRepeatDaySelection(at: index, isSelected: isSelected)
                    self?.validateCanSave()
                case .selectAlarm(let title, let isSelected):
                    self?.handleAlarmSelection(title: title, isSelected: isSelected)
                case .tapSaveTodoButton:
                    self?.saveEvent()
                }
            }
            .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }
    
    func setupInitialDate(with date: Date, isEditMode: Bool) {
        guard !isEditMode else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let initialDate = dateFormatter.string(from: date)
        startDate = initialDate
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
            output.send(.savedEvent)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func updateRoutine() async {
        do {
            guard let routineId = preEvent?.id, let routine = preEvent as? Routine else { return }
            try await updateRoutineUseCase.execute(
                routineId: routineId,
                routine: createRoutine(),
                preRoutine: routine
            )
            output.send(.savedEvent)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
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
        
        let isAllDaySet = isAllDay != nil
        let isTimeSet = time != nil
        if !(isAllDaySet || isTimeSet) {
            missingFields.append("timeOrIsAllDay")
        }
        
        return missingFields
    }
    
    private func validateRoutineInputs() -> [String] {
        var missingFields: [String] = []
        if title == nil { missingFields.append("title") }
        if selectedCategory == nil { missingFields.append("category") }
        if repeatDays == nil || repeatDays?.isEmpty == true { missingFields.append("repeatDays") }
        
        let isAllDaySet = isAllDay != nil
        let isTimeSet = time != nil
        if !(isAllDaySet || isTimeSet) {
            missingFields.append("timeOrIsAllDay")
        }
        
        return missingFields
    }
    
    // MARK: - Object Creation
    private func createSchedule() -> Schedule {
        if endDate == nil {
            endDate = startDate
        }
        
        let isAllDay = time == nil
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
        let isAllDay = time == nil
        let routine = Routine(
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
        
        return routine
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
    
    private func handleAlarmSelection(title: String, isSelected: Bool) {
        if title.isEmpty {
            alarm = nil
            TDLogger.info("알람 초기화됨 (타이틀 없음)")
            return
        }
        
        let titleToAlarmMap: [String: AlarmTime] = [
            "10분 전": .tenMinutesBefore,
            "30분 전": .thirtyMinutesBefore,
            "1시간 전": .oneHourBefore,
            "1일 전": .oneDayBefore
        ]
        
        guard let selectedAlarm = titleToAlarmMap[title] else {
            TDLogger.error("Invalid alarm title: \(title)")
            return
        }
        
        if isSelected {
            alarm = selectedAlarm
            TDLogger.info("알람 선택됨: \(selectedAlarm)")
        } else {
            alarm = nil
            TDLogger.info("알람 해제됨")
        }
    }
    
    private func validateCanSave() {
        let hasTitle = !(title?.isEmpty ?? true)
        let hasValidTime = isAllDay != nil || time != nil
        let hasRepeatDays = !(repeatDays?.isEmpty ?? true)
        var canSave = false
        
        switch mode {
        case .schedule:
            canSave = hasTitle && hasValidTime
        case .routine:
            canSave = hasTitle && hasValidTime && hasRepeatDays
        }
        output.send(.canSaveEvent(canSave))
    }
}
