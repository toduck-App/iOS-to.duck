import FSCalendar
import TDCore
import Combine
import UIKit
import TDDesign

final class ScheduleAndRoutineViewController: BaseViewController<BaseView>, TDPopupPresentable {
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
    private let eventMakorFloattingButton = TDBaseButton(
        title: "일정추가",
        image: TDImage.addSmall,
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 24,
        font: TDFont.boldHeader4.font
    )
    // MARK: - Properties
    private let mode: Mode
    private var selectedDate: Date?
    private let scheduleViewModel: ScheduleViewModel?
    private let routineViewModel: RoutineViewModel?
    private let createInput = PassthroughSubject<ScheduleViewModel.Input, Never>()
    private let modifyInput = PassthroughSubject<RoutineViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: EventMakorDelegate?
    
    // MARK: - Initialize
    init(
        scheduleViewModel: ScheduleViewModel? = nil,
        routineViewModel: RoutineViewModel? = nil,
        mode: Mode
    ) {
        self.scheduleViewModel = scheduleViewModel
        self.routineViewModel = routineViewModel
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        scheduleViewModel = nil
        routineViewModel = nil
        mode = .schedule
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        selectedDate = today
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        weekCalendarView.select(today)
        weekCalendarView.setCurrentPage(startOfWeek, animated: false)
    }
    
    // MARK: Base Method
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        weekCalendarView.delegate = self
        configureEventMakorButton()
        
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
    
    override func addView() {
        view.addSubview(weekCalendarView)
        view.addSubview(scheduleAndRoutineTableView)
        view.addSubview(eventMakorFloattingButton)
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
        
        eventMakorFloattingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(LayoutConstants.buttonTrailingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(LayoutConstants.buttonBottomInset)
            $0.width.equalTo(LayoutConstants.buttonWidth)
            $0.height.equalTo(LayoutConstants.buttonHeight)
        }
    }
    
    private func configureEventMakorButton() {
        eventMakorFloattingButton.setTitle(
            mode == .schedule ? "일정추가" : "루틴추가",
            for: .normal
        )
        eventMakorFloattingButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.coordinator?.didTapEventMakor(mode: self.mode, selectedDate: selectedDate)
        }, for: .touchUpInside)
    }
    
    private func colorForDate(_ date: Date) -> UIColor? {
        // 오늘 날짜 확인
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return TDColor.Primary.primary500
        }
        
        return TDColor.Neutral.neutral600
    }
}

// MARK: - FSCalendarDelegate
extension ScheduleAndRoutineViewController: FSCalendarDelegate {
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
extension ScheduleAndRoutineViewController: FSCalendarDelegateAppearance {
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
    
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        selectedDate = date
    }
}

// MARK: - UITableViewDataSource
extension ScheduleAndRoutineViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch mode {
        case .schedule:
            return scheduleViewModel?.timeSlots.reduce(0) { $0 + $1.events.count } ?? 0
        case .routine:
            return routineViewModel?.timeSlots.reduce(0) { $0 + $1.events.count } ?? 0
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
extension ScheduleAndRoutineViewController: UITableViewDelegate {
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

// MARK: - Layout Constants
extension ScheduleAndRoutineViewController {
    private enum LayoutConstants {
        static let calendarTopOffset: CGFloat = 20
        static let calendarHorizontalInset: CGFloat = 16
        static let calendarHeight: CGFloat = 220
        static let tableViewTopOffset: CGFloat = 20
        static let tableViewContentInsetTop: CGFloat = 12
        static let buttonTrailingInset: CGFloat = -20
        static let buttonBottomInset: CGFloat = -20
        static let buttonWidth: CGFloat = 120
        static let buttonHeight: CGFloat = 48
    }
}
