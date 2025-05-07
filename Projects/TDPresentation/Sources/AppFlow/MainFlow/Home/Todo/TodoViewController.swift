import FSCalendar
import TDDomain
import TDCore
import Combine
import UIKit
import TDDesign

final class TodoViewController: BaseViewController<BaseView> {
    enum TimeLineCellItem: Hashable {
        case allDay(event: any Eventable, showTime: Bool)
        case timeEvent(hour: Int, event: any Eventable, showTime: Bool)
        case gap(startHour: Int, endHour: Int)
    }
    
    // MARK: - UI Components
    private let weekCalendarView = HomeCalendar()
    private let todoTableView = UITableView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.separatorStyle = .none
    }
    private let noTodoContainerView = UIView()
    private let noTodoImageView = UIImageView(image: TDImage.noEvent)
    private let noTodoLabel = TDLabel(
        labelText: "등록된 투두가 없어요",
        toduckFont: TDFont.boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let dimmedView = UIView().then {
        $0.backgroundColor = TDColor.baseBlack.withAlphaComponent(0.5)
        $0.alpha = 0
        $0.isHidden = true
    }
    private let floatingActionMenuView = FloatingActionMenuView()
    private let buttonShadowWrapper = UIView()
    private let eventMakorFloattingButton = TDBaseButton(
        image: TDImage.addLarge,
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 25,
        font: TDFont.boldHeader4.font
    )
    
    // MARK: - Properties
    private let viewModel: TodoViewModel
    private let input = PassthroughSubject<TodoViewModel.Input, Never>()
    private var timelineDataSource: UITableViewDiffableDataSource<Int, TimeLineCellItem>?
    private var cancellables = Set<AnyCancellable>()
    private var selectedDate = Date()
    private var isMenuVisible = false
    private var didAddDimmedView = false
    weak var delegate: TodoViewControllerDelegate?
    
    // MARK: - Initializer
    init(
        viewModel: TodoViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? Date()
        
        weekCalendarView.select(selectedDate)
        weekCalendarView.setCurrentPage(startOfWeek, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFloatingUIInWindow()
        fetchWeekTodo(for: selectedDate)
        input.send(.didSelectedDate(date: selectedDate))
        eventMakorFloattingButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideFloatingViews()
    }
    
    private func fetchWeekTodo(for date: Date) {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: date) else { return }
        
        let startDate = weekInterval.start.convertToString(formatType: .yearMonthDay)
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 6,
            to: weekInterval.start
        )?.convertToString(formatType: .yearMonthDay) ?? startDate
        
        input.send(.fetchWeeklyTodoList(startDate: startDate, endDate: endDate))
    }
    
    // MARK: 플로팅 버튼 처리
    private func setupFloatingUIInWindow() {
        guard !didAddDimmedView,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        addFloatingViewsToWindow(window)
        setupFloatingConstraints(in: window)
        resetDimmedView()
    }

    private func resetDimmedView() {
        dimmedView.alpha = 0
        dimmedView.isHidden = true
        didAddDimmedView = true
        floatingActionMenuView.isHidden = true
    }
    
    private func addFloatingViewsToWindow(_ window: UIWindow) {
        window.addSubview(dimmedView)
        window.addSubview(floatingActionMenuView)
        window.addSubview(buttonShadowWrapper)
        buttonShadowWrapper.addSubview(eventMakorFloattingButton)
    }
    
    private func setupFloatingConstraints(in window: UIWindow) {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonShadowWrapper.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(LayoutConstants.buttonTrailingInset)
            $0.bottom.equalTo(window.safeAreaLayoutGuide.snp.bottom).offset(-84)
            $0.width.equalTo(LayoutConstants.buttonWidth)
            $0.height.equalTo(LayoutConstants.buttonHeight)
        }
        
        floatingActionMenuView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(buttonShadowWrapper.snp.top).offset(-18)
            $0.width.equalTo(120)
            $0.height.equalTo(88)
        }
        
        eventMakorFloattingButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func hideFloatingViews() {
        dimmedView.removeFromSuperview()
        floatingActionMenuView.removeFromSuperview()
        buttonShadowWrapper.removeFromSuperview()
        
        didAddDimmedView = false
        isMenuVisible = false
        resetFloatingButtonAppearance()
    }
    
    private func resetFloatingButtonAppearance() {
        eventMakorFloattingButton.updateBackgroundColor(
            buttonColor: TDColor.Primary.primary500,
            imageColor: TDColor.baseWhite
        )
        let angle: CGFloat = 0
        eventMakorFloattingButton.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    // MARK: Base Method
    override func addView() {
        view.addSubview(weekCalendarView)
        view.addSubview(todoTableView)
        view.addSubview(noTodoContainerView)
        noTodoContainerView.addSubview(noTodoImageView)
        noTodoContainerView.addSubview(noTodoLabel)
    }
    
    override func layout() {
        weekCalendarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.calendarTopOffset)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.calendarHorizontalInset)
            $0.height.equalTo(LayoutConstants.calendarHeight)
        }
        
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(weekCalendarView.snp.bottom).offset(LayoutConstants.tableViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        noTodoContainerView.snp.makeConstraints {
            $0.top.equalTo(weekCalendarView.snp.bottom).offset(LayoutConstants.tableViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        noTodoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(96)
        }
        noTodoLabel.snp.makeConstraints {
            $0.top.equalTo(noTodoImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedTodoList,
                        .deletedTodo:
                    self?.input.send(.didSelectedDate(date: self?.selectedDate ?? Date()))
                case .fetchedRoutineDetail(let routine):
                    let eventDisplayItem = EventDisplayItem(routine: routine)
                    let currentDate = self?.selectedDate.convertToString(formatType: .yearMonthDayKorean) ?? ""
                    let detailEventViewController = DetailEventViewController(mode: .routine, event: eventDisplayItem, currentDate: currentDate)
                    detailEventViewController.delegate = self
                    self?.presentPopup(with: detailEventViewController)
                case .unionedTodoList:
                    self?.applyTimelineSnapshot()
                    let isHidden = self?.viewModel.timedTodoList.isEmpty ?? true && self?.viewModel.allDayTodoList.isEmpty ?? true
                    self?.noTodoContainerView.isHidden = !isHidden
                    self?.todoTableView.isHidden = isHidden
                case .successFinishTodo,
                        .tomorrowTodoCreated:
                    self?.fetchWeekTodo(for: self?.selectedDate ?? Date())
                case .failure(let error):
                    self?.showErrorAlert(errorMessage: error)
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        noTodoContainerView.backgroundColor = TDColor.Neutral.neutral50
        weekCalendarView.delegate = self
        todoTableView.delegate = self
        floatingActionMenuView.isHidden = true
        floatingActionMenuView.delegate = self
        configureEventMakorButton()
        configureDimmedViewGesture()
        configureTodoDataSource()
        registerCell()
        todoTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    private func registerCell() {
        todoTableView.register(
            TimeSlotTableViewCell.self,
            forCellReuseIdentifier: TimeSlotTableViewCell.identifier
        )
        todoTableView.register(
            TimeSlotGapCell.self,
            forCellReuseIdentifier: TimeSlotGapCell.identifier
        )
    }
    
    // MARK: 플로팅 버튼 액션 처리
    private func configureEventMakorButton() {
        buttonShadowWrapper.layer.shadowColor = TDColor.Neutral.neutral800.cgColor
        buttonShadowWrapper.layer.shadowOpacity = 0.3
        buttonShadowWrapper.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonShadowWrapper.layer.shadowRadius = 10
        buttonShadowWrapper.layer.masksToBounds = false
        
        eventMakorFloattingButton.addAction(UIAction { [weak self] _ in
            HapticManager.impact(.soft)
            self?.updateFloatingView()
        }, for: .touchUpInside)
    }
    
    private func updateFloatingView() {
        isMenuVisible.toggle()
        floatingActionMenuView.isHidden = !isMenuVisible
        dimmedView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = self.isMenuVisible ? 1 : 0
            self.eventMakorFloattingButton.updateBackgroundColor(
                buttonColor: self.isMenuVisible ? TDColor.baseWhite : TDColor.Primary.primary500,
                imageColor: self.isMenuVisible ? TDColor.Neutral.neutral700 : TDColor.baseWhite
            )
            let angle: CGFloat = self.isMenuVisible ? .pi / 4 : 0
            self.eventMakorFloattingButton.transform = CGAffineTransform(rotationAngle: angle)
        }) { _ in
            if !self.isMenuVisible {
                self.dimmedView.isHidden = true
            }
        }
    }
    
    private func configureDimmedViewGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapDimmedView)
        )
        dimmedView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func didTapDimmedView() {
        if isMenuVisible {
            updateFloatingView()
        }
    }
    
    func updateCalendarForThisWeek() {
        let today = Date()
        selectedDate = today

        let calendar = Calendar.current
        if let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start {
            weekCalendarView.select(today)
            weekCalendarView.setCurrentPage(startOfWeek, animated: true)
            fetchWeekTodo(for: today)
        }
    }
}

// MARK: - FSCalendar Delegate
extension TodoViewController: FSCalendarDelegate {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDate = date
        input.send(.didSelectedDate(date: date))
    }
    
    func calendar(
        _ calendar: FSCalendar,
        boundingRectWillChange bounds: CGRect,
        animated: Bool
    ) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        fetchWeekTodo(for: calendar.currentPage)
    }
}

// MARK: - FSCalendar Delegate Appearance
extension TodoViewController: FSCalendarDelegateAppearance {
    private func colorForDate(_ date: Date) -> UIColor? {
        // 오늘 날짜 확인
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return TDColor.Primary.primary500
        }
        
        return TDColor.Neutral.neutral600
    }
    
    // 기본 폰트 색
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleDefaultColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
    
    // 선택된 날짜 폰트 색 (이걸 안 하면 오늘날짜와 토,일 선택했을 때 폰트색이 바뀜)
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        colorForDate(date)
    }
}

// MARK: - UITableView Delegate
extension TodoViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let item = timelineDataSource?.itemIdentifier(for: indexPath) else { return }
        let detailEventViewController: DetailEventViewController
        let currentDate = selectedDate.convertToString(formatType: .yearMonthDayKorean)
        
        // TODO: 로직 개선하기
        /// 현재 로직에서 일정은 그냥 바로 팝업 띄우고,
        /// 루틴은 추가 정보가 필요해서 루틴 상세 API를 조회하고, binding 메소드에서 팝업 띄우게 해뒀음
        switch item {
        case .allDay(let event, _):
            if event.eventMode == .schedule, let schedule = event as? Schedule {
                let eventDisplayItem = EventDisplayItem(from: event, place: schedule.place)
                detailEventViewController = DetailEventViewController(mode: event.eventMode, event: eventDisplayItem, currentDate: currentDate)
                detailEventViewController.delegate = self
                presentPopup(with: detailEventViewController)
            } else {
                input.send(.fetchRoutineDetail(event))
            }
        case .timeEvent(_, let event, _):
            if event.eventMode == .schedule, let schedule = event as? Schedule {
                let eventDisplayItem = EventDisplayItem(from: event, place: schedule.place)
                detailEventViewController = DetailEventViewController(mode: event.eventMode, event: eventDisplayItem, currentDate: currentDate)
                detailEventViewController.delegate = self
                presentPopup(with: detailEventViewController)
            } else {
                input.send(.fetchRoutineDetail(event))
            }
        case .gap(_, _):
            break
        }
    }
}

// MARK: - FloatingActionMenuView Delegate
extension TodoViewController: FloatingActionMenuViewDelegate {
    func didTapScheduleButton() {
        delegate?.didTapEventMakor(mode: .schedule, selectedDate: selectedDate, preEvent: nil)
    }
    
    func didTapRoutineButton() {
        delegate?.didTapEventMakor(mode: .routine, selectedDate: selectedDate, preEvent: nil)
    }
}

// MARK: - TableView Diffable DataSource
extension TodoViewController {
    private func configureTodoDataSource() {
        timelineDataSource = UITableViewDiffableDataSource<Int, TimeLineCellItem>(
            tableView: todoTableView
        ) { tableView, indexPath, item in
            switch item {
            case .allDay(let event, let showTime):
                return self.makeTimeSlotCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    hour: Int.max,
                    event: event,
                    showTime: showTime
                )
                
            case .timeEvent(let hour, let event, let showTime):
                return self.makeTimeSlotCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    hour: hour,
                    event: event,
                    showTime: showTime
                )
                
            case .gap(let startHour, let endHour):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TimeSlotGapCell.identifier,
                    for: indexPath
                ) as? TimeSlotGapCell else {
                    return UITableViewCell()
                }
                
                cell.configure(startHour: startHour, endHour: endHour)
                return cell
            }
        }
    }
    
    private func makeTimeSlotCell(
        tableView: UITableView,
        indexPath: IndexPath,
        hour: Int,
        event: any Eventable,
        showTime: Bool
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TimeSlotTableViewCell.identifier,
            for: indexPath
        ) as? TimeSlotTableViewCell else { return UITableViewCell() }
        
        let place = event.eventMode == .schedule ? (event as? Schedule)?.place : nil
        let eventDisplay = EventDisplayItem(from: event, place: place)
        
        cell.configure(
            hour: hour,
            showTime: showTime,
            event: eventDisplay,
            checkBoxAction: { [weak self] in
                HapticManager.impact(.soft)
                self?.input.send(.checkBoxTapped(todo: event))
            },
            editAction: { [weak self] in
                let mode: EventMakorViewController.Mode = eventDisplay.eventMode == .schedule ? .schedule : .routine
                self?.delegate?.didTapEventMakor(
                    mode: mode,
                    selectedDate: self?.selectedDate,
                    preEvent: event
                )
            },
            deleteAction: { [weak self] in
                let isSchedule = eventDisplay.eventMode == .schedule
                let deleteEventViewController = DeleteEventViewController(
                    eventId: eventDisplay.id,
                    isRepeating: eventDisplay.isRepeating,
                    eventMode: isSchedule ? .schedule : .routine
                )
                deleteEventViewController.delegate = self
                self?.presentPopup(with: deleteEventViewController)
            }
        )
        
        return cell
    }
    
    private func applyTimelineSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TimeLineCellItem>()
        snapshot.appendSections([0])
        let items = makeTimelineItems()
        snapshot.appendItems(items, toSection: 0)
        timelineDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeTimelineItems() -> [TimeLineCellItem] {
        var items: [TimeLineCellItem] = []
        let calendar = Calendar.current

        // 종일 이벤트 추가
        for (index, event) in viewModel.allDayTodoList.enumerated() {
            let showTime = (index == 0)
            items.append(.allDay(event: event, showTime: showTime))
        }

        // 시간 이벤트가 없으면 gap 없이 반환
        guard !viewModel.timedTodoList.isEmpty else {
            return items
        }

        // 시간별 매핑
        var eventMapping: [Int: [any Eventable]] = [:]
        for event in viewModel.timedTodoList {
            if let time = event.time, let dateTime = Date.convertFromString(time, format: .time24Hour) {
                let hourComponent = calendar.component(.hour, from: dateTime)
                eventMapping[hourComponent, default: []].append(event)
            }
        }

        // 시간 셀 및 gap 구성
        var currentHour = 0
        while currentHour < 24 {
            if let events = eventMapping[currentHour], !events.isEmpty {
                for (index, event) in events.enumerated() {
                    let showTime = (index == 0)
                    items.append(.timeEvent(hour: currentHour, event: event, showTime: showTime))
                }
                currentHour += 1
            } else {
                let gapStart = currentHour
                while currentHour < 24, eventMapping[currentHour] == nil {
                    currentHour += 1
                }
                let gapEnd = currentHour - 1
                items.append(.gap(startHour: gapStart, endHour: gapEnd))
            }
        }

        return items
    }
}

// MARK: - DeleteEventViewControllerDelegate
extension TodoViewController: DeleteEventViewControllerDelegate {
    func didTapTodayDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode) {
        if let eventId = eventId {
            let isSchedule = eventMode == .schedule
            input.send(.deleteTodayTodo(todoId: eventId, isSchedule: isSchedule))
        }
    }
    
    func didTapAllDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode) {
        if let eventId = eventId {
            let isSchedule = eventMode == .schedule
            input.send(.deleteAllTodo(todoId: eventId, isSchedule: isSchedule))
        }
    }
}

// MARK: - DetailEventViewControllerDelegate
extension TodoViewController: DetailEventViewControllerDelegate {
    func didTapDeleteButton(event: EventDisplayItem) {
        let deleteEventViewController = DeleteEventViewController(
            eventId: event.id,
            isRepeating: event.isRepeating,
            eventMode: event.eventMode == .schedule ? .schedule : .routine
        )
        deleteEventViewController.delegate = self
        presentPopup(with: deleteEventViewController)
    }
    
    func didTapTomorrowButton(event: EventDisplayItem) {
        if let id = event.id {
            input.send(.moveToTomorrow(todoId: id, event: event))
        }
    }
}

extension TodoViewController.TimeLineCellItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.allDay(e1, s1), .allDay(e2, s2)):
            return e1.id == e2.id &&
                   e1.title == e2.title &&
                   e1.isFinished == e2.isFinished &&
                   s1 == s2

        case let (.timeEvent(h1, e1, s1), .timeEvent(h2, e2, s2)):
            return h1 == h2 &&
                   s1 == s2 &&
                   e1.id == e2.id &&
                   e1.title == e2.title &&
                   e1.isFinished == e2.isFinished

        case let (.gap(s1, e1), .gap(s2, e2)):
            return s1 == s2 && e1 == e2

        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .allDay(event, showTime):
            hasher.combine("allDay")
            hasher.combine(event.id)
            hasher.combine(event.title)
            hasher.combine(event.isFinished)
            hasher.combine(showTime)

        case let .timeEvent(hour, event, showTime):
            hasher.combine("routine")
            hasher.combine(hour)
            hasher.combine(event.id)
            hasher.combine(event.title)
            hasher.combine(event.isFinished)
            hasher.combine(showTime)

        case let .gap(startHour, endHour):
            hasher.combine("gap")
            hasher.combine(startHour)
            hasher.combine(endHour)
        }
    }
}

// MARK: - Layout Constants
extension TodoViewController {
    private enum LayoutConstants {
        static let calendarTopOffset: CGFloat = 20
        static let calendarHorizontalInset: CGFloat = 16
        static let calendarHeight: CGFloat = 220
        static let tableViewTopOffset: CGFloat = 20
        static let tableViewContentInsetTop: CGFloat = 12
        static let buttonTrailingInset: CGFloat = -20
        static let buttonBottomInset: CGFloat = -20
        static let buttonWidth: CGFloat = 50
        static let buttonHeight: CGFloat = 50
    }
}
