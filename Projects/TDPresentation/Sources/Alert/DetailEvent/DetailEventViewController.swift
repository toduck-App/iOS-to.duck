import TDCore
import TDDesign
import UIKit

final class DetailEventViewController: TDPopupViewController<DetailEventView> {
    private let mode: ScheduleAndRoutineViewController.Mode
    private let event: EventPresentable
    
    init(mode: ScheduleAndRoutineViewController.Mode, event: EventPresentable) {
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
        popupContentView.cancelButton.setTitle("닫기", for: .normal)
        popupContentView.dateLabel.setText(event.time ?? "날짜")
        
        popupContentView.categoryImageView.backgroundColor = event.categoryColor
        popupContentView.eventTitleLabel.setText(event.title)
        
        popupContentView.timeDetailView.updateDescription(event.time ?? "시간")
        popupContentView.locationDetailView.updateDescription(event.time ?? "장소")
        popupContentView.repeatDetailView.updateDescription(event.memo ?? "설명")
    }
    
    private func setupButtonAction() {
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismissPopup()
        }, for: .touchUpInside)
    }
}
