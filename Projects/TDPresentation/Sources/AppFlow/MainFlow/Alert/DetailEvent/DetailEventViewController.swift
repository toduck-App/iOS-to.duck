import TDCore
import TDDomain
import TDDesign
import UIKit

final class DetailEventViewController: TDPopupViewController<DetailEventView> {
    // MARK: - Properties
    private let mode: ScheduleAndRoutineViewController.Mode
    private let event: EventDisplayItem
    
    // MARK: - Initializer
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        event: EventDisplayItem
    ) {
        self.mode = mode
        self.event = event
        super.init()
    }
    
    init(routine: Routine) {
        self.mode = .routine
        self.event = EventDisplayItem(routine: routine)
        super.init()
    }
    
    init(schedule: Schedule) {
        self.mode = .schedule
        self.event = EventDisplayItem(schedule: schedule)
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        setupView()
        setupButtonActions()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        configureTitle()
        configureEventDetails()
        configureVisibility()
    }
    
    /// 버튼 액션을 설정
    private func setupButtonActions() {
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }
    
    // MARK: - UI Configuration
    /// 제목 설정
    private func configureTitle() {
        let title = mode == .schedule ? "일정 상세보기" : "루틴 상세보기"
        popupContentView.titleLabel.setText(title)
    }
    
    /// 이벤트 정보 설정
    private func configureEventDetails() {
        popupContentView.dateLabel.setText(event.date ?? "-")
        popupContentView.alarmImageView.image = event.alarmTime != nil
            ? TDImage.Bell.ringingMedium
            : TDImage.Bell.offMedium
        
        popupContentView.categoryImageView.configure(
            radius: 12,
            backgroundColor: event.categoryColor,
            category: event.categoryIcon ?? .add
        )
        popupContentView.eventTitleLabel.setText(event.title)
        
        popupContentView.timeDetailView.updateDescription(event.time ?? "-")
        popupContentView.repeatDetailView.updateDescription(event.repeatDays ?? "-")
        popupContentView.memoContentLabel.setText(event.memo ?? "-")
    }
    
    /// 루틴과 일정에 따라 UI를 다르게 설정
    private func configureVisibility() {
        if mode == .routine {
            popupContentView.placeDetailView.isHidden = true
            popupContentView.lockDetailView.updateDescription(event.isPublic ? "공개" : "비공개")
        } else {
            popupContentView.lockDetailView.isHidden = true
            popupContentView.placeDetailView.updateDescription(event.place ?? "-")
        }
    }
}
