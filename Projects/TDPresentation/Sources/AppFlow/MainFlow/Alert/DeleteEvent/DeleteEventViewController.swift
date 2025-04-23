import TDCore
import Combine
import TDDesign
import UIKit

protocol DeleteEventViewControllerDelegate: AnyObject {
    func didTapTodayDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode)
    func didTapAllDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode)
}

final class DeleteEventViewController: TDPopupViewController<DeleteEventView> {
    enum EventRepeatingMode {
        case single
        case repeating
    }
    
    enum EventMode {
        case schedule
        case routine
        case diary
    }
    
    private let eventId: Int?
    private let mode: EventRepeatingMode
    private let eventMode: EventMode
    weak var delegate: DeleteEventViewControllerDelegate?

    /// - Parameters:
    ///   - isScheduleEvent: 일정인지 루틴인지 여부 (`true`: 일정, `false`: 루틴)
    ///   - eventType: 이벤트 타입 (일정, 루틴, 다이어리)
    init(
        eventId: Int?,
        isRepeating: Bool,
        eventMode: EventMode
    ) {
        self.eventId = eventId
        self.mode = isRepeating ? .repeating : .single
        self.eventMode = eventMode
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        updateButtonTitles()
        setupRepeatingMode()
        setupButtonAction()
    }

    /// 일정 or 루틴에 맞는 버튼 타이틀을 설정
    private func updateButtonTitles() {
        let singleTitle = eventMode == .schedule ? "이 일정만 삭제" : "이 루틴만 삭제"
        let repeatingTitle = eventMode == .schedule ? "이후 일정 모두 삭제" : "이후 루틴 모두 삭제"

        popupContentView.currentEventDeleteButton.setTitle(singleTitle, for: .normal)
        popupContentView.afterEventDeleteButton.setTitle(repeatingTitle, for: .normal)
    }
    
    private func setupRepeatingMode() {
        if mode == .single {
            popupContentView.afterEventContainer.isHidden = mode == .single
            popupContentView.currentEventDeleteButton.setTitle("삭제", for: .normal)
            popupContentView.currentEventDeleteButton.titleLabel?.font = TDFont.boldBody1.font
        }
    }

    private func setupButtonAction() {
        popupContentView.currentEventDeleteButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapTodayDeleteButton(eventId: self?.eventId, eventMode: self?.eventMode ?? .schedule)
        }, for: .touchUpInside)
        
        popupContentView.afterEventDeleteButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapAllDeleteButton(eventId: self?.eventId, eventMode: self?.eventMode ?? .schedule)
        }, for: .touchUpInside)
        
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }
}
