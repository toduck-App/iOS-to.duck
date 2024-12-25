import FSCalendar
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
    private lazy var scheduleAndRoutineCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = TDColor.Neutral.neutral50
        collectionView.register(
            TimeSlotCollectionViewCell.self,
            forCellWithReuseIdentifier: TimeSlotCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Properties
    private let mode: Mode
    private let scheduleViewModel: ScheduleViewModel?
    private let routineViewModel: RoutineViewModel?
    private let createInput = PassthroughSubject<ScheduleViewModel.Input, Never>()
    private let modifyInput = PassthroughSubject<RoutineViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Base Method
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        weekCalendarView.delegate = self
        scheduleAndRoutineCollectionView.delegate = self
        scheduleAndRoutineCollectionView.dataSource = self
        
        scheduleAndRoutineCollectionView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
    
    override func addView() {
        view.addSubview(weekCalendarView)
        view.addSubview(scheduleAndRoutineCollectionView)
    }
    
    override func layout() {
        weekCalendarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(220)
        }
        
        scheduleAndRoutineCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekCalendarView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
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

// MARK: - UICollectionViewDataSource
extension ScheduleAndRoutineViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch mode {
        case .schedule:
            return scheduleViewModel?.timeSlots.reduce(0) { $0 + $1.events.count } ?? 0
        case .routine:
            return routineViewModel?.timeSlots.reduce(0) { $0 + $1.events.count } ?? 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeSlotCollectionViewCell.identifier,
            for: indexPath
        ) as? TimeSlotCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 모드에 따라 뷰모델 선택
        let provider: TimeSlotProvider? = (mode == .schedule) ? scheduleViewModel : routineViewModel
        
        guard let timeSlots = provider?.timeSlots else { return cell }
        
        // cumulativeCount로 indexPath.row가 속한 TimeSlot 찾기
        var cumulative = 0
        for slot in timeSlots {
            let count = slot.events.count
            if indexPath.row < cumulative + count {
                let eventIndexInSlot = indexPath.row - cumulative
                let event = slot.events[eventIndexInSlot]
                
                // 첫 번째 이벤트인 경우 시간 레이블 표시
                let timeText: String? = (eventIndexInSlot == 0) ? slot.timeText : nil
                
                cell.configure(
                    timeText: timeText,
                    event: event
                )
                break
            }
            cumulative += count
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ScheduleAndRoutineViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completion) in
            // indexPath.row에 해당하는 이벤트 삭제 로직
            // dataSource에서 events를 제거 후 collectionView.reloadData() (or performBatchUpdates)
            completion(true)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        // 스와이프 후에도 배경 고정 여부
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
}
