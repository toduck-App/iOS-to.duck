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
    private var selectedDate: Date?
    weak var coordinator: ToduckCalendarCoordinator?
    
    init(viewModel: ToduckCalendarViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 이번 달 일정들 조회
        let startDate = Date().startOfMonth()
        let endDate = Date().endOfMonth()
        input.send(
            .fetchSchedule(
                startDate: startDate.convertToString(formatType: .yearMonthDay),
                endDate: endDate.convertToString(formatType: .yearMonthDay),
                isMonth: true
            )
        )
        setupCalendar()
        setupGesture()
        selectToday()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dateString = selectedDate?.convertToString(formatType: .yearMonthDay) {
            input.send(.fetchSchedule(startDate: dateString, endDate: dateString, isMonth: false))
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isInitialLayoutDone {
            updateConstants()
            selectedDayViewTopConstraint?.update(offset: selectedDayViewTopCollapsed)
            isInitialLayoutDone = true
        }
        view.bringSubviewToFront(selectedDayScheduleView)
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
        selectedDayScheduleView.scheduleTableView.dataSource = self
        selectedDayScheduleView.scheduleTableView.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchedScheduleList:
                    self?.selectedDayScheduleView.scheduleTableView.reloadData()
                case .successFinishSchedule:
                    if let formattedDate = self?.selectedDate {
                        let dateString = formattedDate.convertToString(formatType: .yearMonthDay)
                        self?.input.send(.fetchSchedule(startDate: dateString, endDate: dateString, isMonth: false))
                    }
                case .failure(let errorMessage):
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }.store(in: &cancellables)
    }
    
    private func selectToday() {
        let today = Date()
        calendar.select(today)
        selectedDate = today
        viewModel.selectedDate = today
        selectedDayScheduleView.updateDateLabel(date: today)
    }
}

private extension ToduckCalendarViewController {
    private enum Constant {
        static let calendarHeaderTopOffset: CGFloat = 30
        static let calendarTopOffset: CGFloat = 20
        static let calendarHeight: CGFloat = 334
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
        
        // 먼저 rowHeight를 계산
        let headerHeight = calendar.headerHeight
        let weekdayHeight = calendar.weekdayHeight
        let numberOfRows: CGFloat = 6 // 최대 6주
        let newRowHeight = (newCalendarHeight - headerHeight - weekdayHeight) / numberOfRows
        
        // 애니메이션과 함께 변경사항 적용
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

// MARK: - FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate
extension ToduckCalendarViewController: TDCalendarConfigurable {
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDayScheduleView.updateDateLabel(date: date)
        
        let dateString = date.convertToString(formatType: .yearMonthDay)
        viewModel.selectedDate = date
        input.send(.fetchSchedule(startDate: dateString, endDate: dateString, isMonth: false))
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderLabel(for: calendar.currentPage)
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
}

// MARK: - UITableViewDataSource
extension ToduckCalendarViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.currentDayScheduleList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleDetailCell.identifier,
            for: indexPath
        ) as? ScheduleDetailCell else {
            return UITableViewCell()
        }

        let schedule = viewModel.currentDayScheduleList[indexPath.row]
        cell.configure(with: schedule) { [weak self] in
            self?.input.send(.checkBoxTapped(schedule))
        }

        return cell
    }
}
