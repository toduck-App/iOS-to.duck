import FSCalendar
import TDCore
import Combine
import UIKit
import TDDesign

final class ScheduleAndRoutineViewController: BaseViewController<BaseView> {
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
    private let eventMakorFloattingButton = TDButton(
        title: "일정 추가",
        size: .large,
        foregroundColor: TDColor.baseWhite,
        backgroundColor: TDColor.Primary.primary500
    )
    
    // MARK: - Properties
    private let mode: Mode
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
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(220)
        }
        
        scheduleAndRoutineTableView.snp.makeConstraints {
            $0.top.equalTo(weekCalendarView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        eventMakorFloattingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.width.equalTo(116)
            $0.height.equalTo(48)
        }
    }
    
    private func configureEventMakorButton() {
        eventMakorFloattingButton.layer.cornerRadius = 24
        eventMakorFloattingButton.setImage(
            TDImage.addLarge,
            for: .normal
        )
        eventMakorFloattingButton.setTitle(
            mode == .schedule ? " 일정 추가" : " 루틴 추가",
            for: .normal
        )
        eventMakorFloattingButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapEventMakor()
        }, for: .touchUpInside)
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
        
        guard let timeSlots = provider?.timeSlots else { return cell }
        
        var cumulative = 0
        for slot in timeSlots {
            let count = slot.events.count
            if indexPath.row < cumulative + count {
                let eventIndexInSlot = indexPath.row - cumulative
                let event = slot.events[eventIndexInSlot]
                
                let timeText: String? = (eventIndexInSlot == 0) ? slot.timeText : nil
                
                cell.configure(
                    timeText: timeText,
                    event: event
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
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { _, _, completion in
            print("삭제 액션 실행됨")
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "수정"
        ) { _, _, completion in
            print("수정 액션 실행됨")
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
