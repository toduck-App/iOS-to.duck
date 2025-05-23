import FSCalendar
import SnapKit
import TDDesign
import UIKit
import Combine

final class ToduckCalendarViewController: BaseViewController<BaseView> {
    // MARK: Nested Types
    private enum DetailViewState {
        case topExpanded
        case topCollapsed
    }
    
    // MARK: - UI Components
    let calendarHeader = CalendarHeaderStackView(type: .toduck)
    let calendar = ToduckCalendar()
    private let selectedDayScheduleView = SelectedDayScheduleView()
    
    // MARK: - Properties
    private let viewModel: ToduckCalendarViewModel
    private let input = PassthroughSubject<ToduckCalendarViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var calendarHeightConstraint: Constraint?
    private var selectedDayViewTopConstraint: Constraint?
    private var selectedDayViewTopExpanded: CGFloat = 0
    private var selectedDayViewTopCollapsed: CGFloat = 0
    private var isInitialLayoutDone = false  // 첫 실행 때만 레이아웃 업데이트
    private var isDetailCalendarMode = false // 캘린더가 화면 꽉 채우는지
    private var currentDetailViewState: DetailViewState = .topCollapsed
    private var initialDetailViewState: DetailViewState = .topCollapsed
    private var currentMonthStartDate = Date().startOfMonth()
    private var currentMonthEndDate = Date().endOfMonth()
    private var selectedDate = Date()
    weak var coordinator: ToduckCalendarCoordinator?
    
    // MARK: - Initializer
    init(viewModel: ToduckCalendarViewModel) {
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
        
        fetchScheduleList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchScheduleList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubviewToFront(selectedDayScheduleView)
        input.send(.fetchDetailSchedule(date: selectedDate))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isInitialLayoutDone {
            updateConstants()
            selectedDayViewTopConstraint?.update(offset: selectedDayViewTopCollapsed)
            view.layoutIfNeeded()
            isInitialLayoutDone = true
        }
    }
    
    private func updateConstants() {
        let calendarHeaderHeight = calendarHeader.frame.height
        let calendarHeight = calendar.frame.height
        
        selectedDayViewTopExpanded = view.safeAreaInsets.top
        selectedDayViewTopCollapsed = calendarHeaderHeight + selectedDayViewTopExpanded + Constant.calendarTopOffset + calendarHeight
    }
    
    // MARK: - Setup
    override func addView() {
        view.addSubview(calendarHeader)
        view.addSubview(calendar)
        view.addSubview(selectedDayScheduleView)
    }
    
    override func layout() {
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(18)
        }
        calendar.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(calendarHeader.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(8)
            self.calendarHeightConstraint = $0.height.equalTo(Constant.calendarHeight).constraint
        }
        selectedDayScheduleView.snp.makeConstraints {
            self.selectedDayViewTopConstraint = $0.top.equalTo(view).constraint
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configure() {
        view.backgroundColor = .white
        setupCalendar()
        setupGesture()
        selectToday()
        calendarHeader.delegate = self
        selectedDayScheduleView.scheduleTableView.dataSource = self
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .fetchedScheduleList:
                    calendar.reloadData()
                    input.send(.fetchDetailSchedule(date: selectedDate))
                case .fetchedDetailSchedule:
                    selectedDayScheduleView.scheduleTableView.reloadData()
                    selectedDayScheduleView.noScheduleLabel.isHidden = !(viewModel.currentDayScheduleList.isEmpty)
                case .successFinishSchedule:
                    selectedDayScheduleView.scheduleTableView.reloadData()
                case .failure(let errorMessage):
                    showErrorAlert(errorMessage: errorMessage)
                case .deletedTodo:
                    fetchScheduleList()
                }
            }.store(in: &cancellables)
    }
    
    private func selectToday() {
        let today = Date()
        calendar.select(today)
        viewModel.selectedDate = today
        selectedDayScheduleView.updateDateLabel(date: today)
    }
    
    private func fetchScheduleList() {
        guard
            let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: calendar.currentPage)),
            let endDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)
        else { return }
        
        currentMonthStartDate = startDate
        currentMonthEndDate = endDate
        
        input.send(
            .fetchSchedule(
                startDate: currentMonthStartDate.convertToString(formatType: .yearMonthDay),
                endDate: currentMonthEndDate.convertToString(formatType: .yearMonthDay)
            )
        )
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        selectedDayScheduleView.headerView.addGestureRecognizer(panGesture)
    }
    
    @objc
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).y
        let velocity = gesture.velocity(in: view).y
        
        switch gesture.state {
        case .began:
            initialDetailViewState = self.currentDetailViewState
            
        case .changed:
            var newTop = (selectedDayViewTopConstraint?.layoutConstraints.first?.constant ?? selectedDayViewTopCollapsed) + translation
            newTop = max(selectedDayViewTopExpanded, min(selectedDayViewTopCollapsed, newTop))
            selectedDayViewTopConstraint?.update(offset: newTop)
            gesture.setTranslation(.zero, in: view)
            
        case .ended, .cancelled:
            let currentTop = selectedDayViewTopConstraint?.layoutConstraints.first?.constant ?? selectedDayViewTopCollapsed
            let targetTop: CGFloat
            let detailViewState: DetailViewState
            
            if abs(velocity) > 500 {
                // 빠른 스와이프 → 방향에 따라 결정
                if velocity < 0 {
                    targetTop = selectedDayViewTopExpanded
                    detailViewState = .topExpanded
                } else {
                    targetTop = selectedDayViewTopCollapsed
                    detailViewState = .topCollapsed
                }
            } else {
                // 느린 스와이프 → 중간 위치 기준
                let middlePosition = (selectedDayViewTopCollapsed + selectedDayViewTopExpanded) / 2
                if currentTop < middlePosition {
                    targetTop = selectedDayViewTopExpanded
                    detailViewState = .topExpanded
                } else {
                    targetTop = selectedDayViewTopCollapsed
                    detailViewState = .topCollapsed
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.selectedDayViewTopConstraint?.update(offset: targetTop)
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.adjustCalendarHeight(for: detailViewState)
                self.currentDetailViewState = detailViewState
            })
            
        default:
            break
        }
    }
    
    private func adjustCalendarHeight(for detailViewState: DetailViewState) {
        let newCalendarHeight: CGFloat = Constant.calendarHeight
        
        let headerHeight = calendar.headerHeight
        let weekdayHeight = calendar.weekdayHeight
        let numberOfRows: CGFloat = 6 // 최대 6주
        let newRowHeight = (newCalendarHeight - headerHeight - weekdayHeight) / numberOfRows
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.calendar.rowHeight = newRowHeight
            self.calendarHeightConstraint?.update(offset: newCalendarHeight)
        }, completion: { [weak self] _ in
            guard let self else { return }
            self.calendar.setNeedsLayout()
            self.calendar.layoutIfNeeded()
        })
    }
}

// MARK: - CalendarHeaderStackViewDelegate
extension ToduckCalendarViewController: CalendarHeaderStackViewDelegate {
    func calendarHeader(
        _ header: CalendarHeaderStackView,
        didSelect date: Date
    ) {
        calendar.setCurrentPage(date, animated: true)
        updateHeaderLabel(for: calendar.currentPage)
    }
}

// MARK: - FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate
extension ToduckCalendarViewController: TDCalendarConfigurable {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDayScheduleView.updateDateLabel(date: date)
        viewModel.selectedDate = date
        input.send(.fetchDetailSchedule(date: date))
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        updateHeaderLabel(for: currentPage)
        fetchScheduleList()
    }
    
    // MARK: - 날짜 폰트 색상
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
    
    // MARK: 날짜 아래 점 표시
    func calendar(
        _ calendar: FSCalendar,
        numberOfEventsFor date: Date
    ) -> Int {
        let key = Calendar.current.startOfDay(for: date)
        let schedules = viewModel.monthScheduleDict[key] ?? []
        return min(3, schedules.count)
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventDefaultColorsFor date: Date
    ) -> [UIColor]? {
        let key = Calendar.current.startOfDay(for: date)
        let schedules = viewModel.monthScheduleDict[key] ?? []
        let categoryColors = schedules.prefix(3).map { $0.categoryColor }
        let colors = categoryColors.compactMap { TDColor.reversedOpacityFrontPair[ColorValue(color: $0)] }
        return colors
    }
    
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventSelectionColorsFor date: Date
    ) -> [UIColor]? {
        let key = Calendar.current.startOfDay(for: date)
        let schedules = viewModel.monthScheduleDict[key] ?? []
        let categoryColors = schedules.prefix(3).map { $0.categoryColor }
        let colors = categoryColors.compactMap { TDColor.reversedOpacityFrontPair[ColorValue(color: $0)] }
        return colors
    }
}

// MARK: - UITableViewDataSource
extension ToduckCalendarViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.currentDayScheduleList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleDetailTableViewCell.identifier,
            for: indexPath
        ) as? ScheduleDetailTableViewCell else { return UITableViewCell() }
        
        let schedule = viewModel.currentDayScheduleList[indexPath.row]
        
        cell.configure(
            with: schedule,
            checkAction: { [weak self] in
                self?.input.send(.checkBoxTapped(schedule))
            },
            editAction: { [weak self] in
                self?.coordinator?.didTapTodoMakor(
                    mode: .schedule,
                    selectedDate: self?.selectedDate,
                    preTodo: schedule,
                    delegate: nil
                )
            },
            deleteAction: { [weak self] in
                let deleteEventViewController = DeleteEventViewController(
                    eventId: schedule.id,
                    isRepeating: schedule.isRepeating,
                    eventMode: .schedule
                )
                deleteEventViewController.delegate = self
                self?.presentPopup(with: deleteEventViewController)
            }
        )
        
        return cell
    }
}

// MARK: - DeleteEventViewControllerDelegate
extension ToduckCalendarViewController: DeleteEventViewControllerDelegate {
    func didTapTodayDeleteButton(
        eventId: Int?,
        eventMode: DeleteEventViewController.EventMode
    ) {
        if let eventId = eventId {
            input.send(.deleteTodayTodo(scheduleId: eventId))
        }
    }
    
    func didTapAllDeleteButton(
        eventId: Int?,
        eventMode: DeleteEventViewController.EventMode
    ) {
        if let eventId = eventId {
            input.send(.deleteAllTodo(scheduleId: eventId))
        }
    }
}


extension ToduckCalendarViewController {
    private enum Constant {
        static let calendarHeaderTopOffset: CGFloat = 30
        static let calendarTopOffset: CGFloat = 20
        static let calendarHeight: CGFloat = 334
    }
}
