import TDCore
import TDDesign
import TDDomain
import UIKit

final class EventSheetViewController: BaseViewController<EventSheetView>, EventSheetViewDelegate {
    let events: [TDEvent]
    init(events: [TDEvent]) {
        self.events = events
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        layoutView.backgroundColor = TDColor.baseWhite
        layoutView.configure(image: TDImage.Event.socialThumnail)
        layoutView.delegate = self
    }
    
    func eventSheetDidTapViewDetails(_ view: EventSheetView) {
        dismiss(animated: true)
    }
    
    func eventSheetDidTapHideToday(_ view: EventSheetView) {
        TDTokenManager.shared.markEventSheetHiddenForToday()
        dismiss(animated: true)
    }
    
    func eventSheetDidTapClose(_ view: EventSheetView) {
        dismiss(animated: true)
    }
}
