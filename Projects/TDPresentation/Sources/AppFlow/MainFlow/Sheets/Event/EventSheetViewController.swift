import TDCore
import TDDesign
import TDDomain
import UIKit

final class EventSheetViewController: BaseViewController<EventSheetView>, EventSheetViewDelegate {
    weak var coordinator: EventSheetCoordinator?
    
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
        coordinator?.didTapDetailView(eventId: 1)
    }
    
    func eventSheetDidTapHideToday(_ view: EventSheetView) {
        TDTokenManager.shared.markEventSheetHiddenForToday()
        coordinator?.finish(by: .sheet(completion: {}))
    }
    
    func eventSheetDidTapClose(_ view: EventSheetView) {
        coordinator?.finish(by: .sheet(completion: {}))
    }
}
