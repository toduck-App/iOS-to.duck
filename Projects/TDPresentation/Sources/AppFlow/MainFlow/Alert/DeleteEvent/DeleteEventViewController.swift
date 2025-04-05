import TDCore
import TDDesign
import UIKit

protocol DeleteEventViewControllerDelegate: AnyObject {
    func didTapDeleteButton()
}

final class DeleteEventViewController: TDPopupViewController<DeleteEventView> {
    enum EventRepeatingMode {
        case single
        case repeating
    }
    
    private let mode: EventRepeatingMode
    private let isScheduleEvent: Bool
    weak var delegate: DeleteEventViewControllerDelegate?

    /// - Parameters:
    ///   - isScheduleEvent: 일정인지 루틴인지 여부 (`true`: 일정, `false`: 루틴)
    ///   - isRepeating: 반복 여부 (`true`: 반복 이벤트, `false`: 단일 이벤트)
    init(
        isRepeating: Bool,
        isScheduleEvent: Bool
    ) {
        self.mode = isRepeating ? .repeating : .single
        self.isScheduleEvent = isScheduleEvent
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
        let singleTitle = isScheduleEvent ? "이 일정만 삭제" : "이 루틴만 삭제"
        let repeatingTitle = isScheduleEvent ? "이후 일정 모두 삭제" : "이후 루틴 모두 삭제"

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
            self?.delegate?.didTapDeleteButton()
        }, for: .touchUpInside)
        
        popupContentView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }
}
