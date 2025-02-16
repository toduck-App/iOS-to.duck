import TDCore
import TDDesign
import UIKit

final class DetailEventViewController: TDPopupViewController<DetailEventView> {
    private let mode: ScheduleAndRoutineViewController.Mode
    private let event: EventDisplayItem
    
    init(
        mode: ScheduleAndRoutineViewController.Mode,
        event: EventDisplayItem
    ) {
        self.mode = mode
        self.event = event
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        updateButtonTitles()
        setupButtonAction()
    }

    /// 일정 or 루틴에 맞는 버튼 타이틀을 설정
    private func updateButtonTitles() {
        popupContentView.titleLabel.setText(mode == .schedule ? "일정 상세보기" : "루틴 상세보기")
        popupContentView.dateLabel.setText(event.date ?? "날짜")
        popupContentView.alarmImageView.image = event.alarmTimes != nil
        ? TDImage.Bell.ringingMedium
        : TDImage.Bell.offMedium
        
        popupContentView.categoryImageView.backgroundColor = event.categoryColor
        popupContentView.eventTitleLabel.setText(event.title)
        
        popupContentView.timeDetailView.updateDescription(event.time ?? "시간")
        popupContentView.repeatDetailView.updateDescription(event.repeatDays ?? "반복")
        popupContentView.locationDetailView.updateDescription(event.place ?? "장소")
    }
    
    private func setupButtonAction() {
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }
}
