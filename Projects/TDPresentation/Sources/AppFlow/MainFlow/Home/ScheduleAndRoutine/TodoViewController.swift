import FSCalendar
import TDCore
import Combine
import UIKit
import TDDesign

final class TodoViewController: BaseViewController<BaseView> {
    enum Mode {
        case schedule
        case routine
    }
    
    // MARK: - UI Components
    private let weekCalendarView = HomeCalendar()
    private let scheduleAndRoutineTableView = UITableView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.separatorStyle = .none
    }
    
    private let dimmedView = UIView().then {
        $0.backgroundColor = TDColor.baseBlack.withAlphaComponent(0.5)
        $0.alpha = 0
        $0.isHidden = true
    }
    private let floatingActionMenuView = FloatingActionMenuView()
    private let buttonShadowWrapper = UIView()
    private let eventMakorFloattingButton = TDBaseButton(
        image: TDImage.addSmall,
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 25,
        font: TDFont.boldHeader4.font
    )
    // MARK: - Properties
    private let mode: Mode
    private let scheduleViewModel: ScheduleViewModel
    private let routineViewModel: RoutineViewModel
    private let scheduleInput = PassthroughSubject<ScheduleViewModel.Input, Never>()
    private let routineInput = PassthroughSubject<RoutineViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var selectedDate: Date?
    private var isMenuVisible = false
    private var didAddDimmedView = false
    weak var coordinator: EventMakorDelegate?
    
    // MARK: - Initializer
    init(
        scheduleViewModel: ScheduleViewModel,
        routineViewModel: RoutineViewModel,
        mode: Mode
    ) {
        self.scheduleViewModel = scheduleViewModel
        self.routineViewModel = routineViewModel
        self.mode = mode
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTodayTodo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let today = Date()
        selectedDate = today
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        weekCalendarView.select(today)
        weekCalendarView.setCurrentPage(startOfWeek, animated: false)
        setupFloatingUIInWindow()
        eventMakorFloattingButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideFloatingViews()
    }
    
    private func fetchTodayTodo() {
        if let startWeekDay = Date().startOfWeek()?.convertToString(formatType: .yearMonthDay),
           let endWeekDay = Date().endOfWeek()?.convertToString(formatType: .yearMonthDay) {
            switch mode {
            case .schedule:
                scheduleInput.send(
                    .fetchScheduleList(
                        startDate: startWeekDay,
                        endDate: endWeekDay
                    )
                )
            case .routine:
                break
            }
        }
    }
    
    // 뷰가 나타날 때 플로팅 버튼 처리
    private func setupFloatingUIInWindow() {
        guard !didAddDimmedView,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        addFloatingViewsToWindow(window)
        setupFloatingConstraints(in: window)
        didAddDimmedView = true
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
    
    // 뷰가 사라질 때 플로팅 버튼 처리
    private func hideFloatingViews() {
        eventMakorFloattingButton.isHidden = true
        floatingActionMenuView.isHidden = true
        dimmedView.isHidden = true
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
        view.addSubview(scheduleAndRoutineTableView)
    }
    
    override func layout() {        
        weekCalendarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.calendarTopOffset)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.calendarHorizontalInset)
            $0.height.equalTo(LayoutConstants.calendarHeight)
        }
        
        scheduleAndRoutineTableView.snp.makeConstraints {
            $0.top.equalTo(weekCalendarView.snp.bottom).offset(LayoutConstants.tableViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func binding() {
        let scheduleOutput = scheduleViewModel.transform(input: scheduleInput.eraseToAnyPublisher())
        let routineOutput = routineViewModel.transform(input: routineInput.eraseToAnyPublisher())
        
        scheduleOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedScheduleList:
                    self?.scheduleAndRoutineTableView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(errorMessage: error)
                }
            }.store(in: &cancellables)
        
        routineOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        weekCalendarView.delegate = self
        floatingActionMenuView.isHidden = true
        floatingActionMenuView.delegate = self
        configureEventMakorButton()
        configureDimmedViewGesture()
        
        scheduleAndRoutineTableView.delegate = self
        scheduleAndRoutineTableView.dataSource = self
        scheduleAndRoutineTableView.register(
            TimeSlotTableViewCell.self,
            forCellReuseIdentifier: TimeSlotTableViewCell.identifier
        )
        scheduleAndRoutineTableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 0,
            right: 0
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDimmedView))
        dimmedView.addGestureRecognizer(tap)
    }
    
    @objc
    private func didTapDimmedView() {
        if isMenuVisible {
            updateFloatingView()
        }
    }
}

// MARK: - FSCalendarDelegate
extension TodoViewController: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentPage)?.start
        let endOfWeek = startOfWeek.flatMap { calendar.date(byAdding: .day, value: 6, to: $0) }
        
        if let startDate = startOfWeek?.convertToString(formatType: .yearMonthDay),
           let endDate = endOfWeek?.convertToString(formatType: .yearMonthDay) {
            switch mode {
            case .schedule:
                scheduleInput.send(
                    .fetchScheduleList(
                        startDate: startDate,
                        endDate: endDate
                    )
                )
            case .routine:
                break
            }
        }
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
}

// MARK: - FSCalendarDelegateAppearance
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
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDate = date
    }
}

// MARK: - UITableViewDataSource
extension TodoViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch mode {
        case .schedule:
            return scheduleViewModel.timeSlots.reduce(0) { $0 + $1.events.count }
        case .routine:
            return routineViewModel.timeSlots.reduce(0) { $0 + $1.events.count }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TimeSlotTableViewCell.identifier,
            for: indexPath
        ) as? TimeSlotTableViewCell else { return UITableViewCell() }
        
        let provider: TimeSlotProvider? = (mode == .schedule) ? scheduleViewModel : routineViewModel
        guard let provider else { return cell }
        
        let isRepeating = provider.isEventRepeating(at: indexPath.row)
        
        cell.configureSwipeActions(
            editAction: { [weak self] in
                print("editAction")
            },
            deleteAction: { [weak self] in
                let deleteEventViewController = DeleteEventViewController(
                    isRepeating: isRepeating,
                    isScheduleEvent: self?.mode == .schedule
                )
                self?.presentPopup(with: deleteEventViewController)
            }
        )
        
        var cumulative = 0
        for slot in provider.timeSlots {
            let count = slot.events.count
            if indexPath.row < cumulative + count {
                let eventIndexInSlot = indexPath.row - cumulative
                let event = slot.events[eventIndexInSlot]
                let eventDisplayItem = provider.convertEventToDisplayItem(event: event)
                
                let timeText: String? = (eventIndexInSlot == 0) ? slot.timeText : nil
                
                cell.configure(
                    timeText: timeText,
                    event: eventDisplayItem
                )
                cell.configureButtonAction {
                    TDLogger.debug("체크박스 버튼눌림")
                }
                break
            }
            cumulative += count
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let provider: TimeSlotProvider? = (mode == .schedule) ? scheduleViewModel : routineViewModel
        guard let provider else { return }
        
        var cumulative = 0
        for slot in provider.timeSlots {
            let count = slot.events.count
            if indexPath.row < cumulative + count {
                let eventIndexInSlot = indexPath.row - cumulative
                let event = slot.events[eventIndexInSlot]
                let eventDisplayItem = provider.convertEventToDisplayItem(event: event)
                let detailEventViewController = DetailEventViewController(mode: mode, event: eventDisplayItem)
                presentPopup(with: detailEventViewController)
                
                return
            }
            cumulative += count
        }
    }
}

extension TodoViewController: FloatingActionMenuViewDelegate {
    func didTapScheduleButton() {
        coordinator?.didTapEventMakor(mode: .schedule, selectedDate: selectedDate)
    }
    
    func didTapRoutineButton() {
        coordinator?.didTapEventMakor(mode: .routine, selectedDate: selectedDate)
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
