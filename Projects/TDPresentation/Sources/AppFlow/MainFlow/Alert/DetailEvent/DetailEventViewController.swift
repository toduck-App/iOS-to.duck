import TDCore
import TDDomain
import TDDesign
import UIKit

final class DetailEventViewController: TDPopupViewController<DetailEventView> {
    // MARK: - Properties
    private let mode: TDEventMode
    private let event: EventDisplayItem
    private let currentDate: String
    
    // MARK: - Initializer
    init(
        mode: TDEventMode,
        event: EventDisplayItem,
        currentDate: String
    ) {
        self.mode = mode
        self.event = event
        self.currentDate = currentDate
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
        popupContentView.dateLabel.setText(currentDate)
        popupContentView.alarmImageView.image = event.alarmTime != nil
            ? TDImage.Bell.ringingMedium
            : TDImage.Bell.offMedium
        
        popupContentView.categoryImageView.configure(
            radius: 12,
            backgroundColor: event.categoryColor,
            category: event.categoryIcon ?? TDImage.Tomato.tomatoSmallEmtpy
        )
        popupContentView.eventTitleLabel.setText(event.title)
        
        popupContentView.timeDetailView.updateDescription(event.time ?? "없음")
        let repeatString = event.repeatDays == nil ? "없음" : event.repeatDays!.map { $0.title }.joined(separator: ", ")
        popupContentView.repeatDetailView.updateDescription(repeatString)
        popupContentView.memoContentLabel.setText(event.memo ?? "없음")
    }
    
    /// 루틴과 일정에 따라 UI를 다르게 설정
    private func configureVisibility() {
        if mode == .routine {
            popupContentView.placeDetailView.isHidden = true
            popupContentView.lockDetailView.updateDescription(event.isPublic ? "공개" : "비공개")
        } else {
            popupContentView.lockDetailView.isHidden = true
            popupContentView.placeDetailView.updateDescription(event.place ?? "없음")
        }
    }
}
