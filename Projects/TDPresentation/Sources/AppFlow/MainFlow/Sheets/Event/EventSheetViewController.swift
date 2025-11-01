import TDCore
import TDDesign
import TDDomain
import UIKit
final class EventSheetViewController: BaseViewController<EventSheetView>, EventSheetViewDelegate {
    weak var coordinator: EventSheetCoordinator?

    let events: [TDEvent]
    let precomputedAspects: [CGFloat?]

    init(events: [TDEvent], precomputedAspects: [CGFloat?] = []) {
        self.events = events
        self.precomputedAspects = precomputedAspects
        super.init()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { fatalError() }

    override func configure() {
        layoutView.backgroundColor = TDColor.baseWhite
        layoutView.delegate = self
        layoutView.configure(events: events, precomputedAspects: precomputedAspects)
    }

    func eventSheetDidTapViewDetails(_ view: EventSheetView) {
        let idx = layoutView.currentPageIndex
        guard events.indices.contains(idx) else { return }
        coordinator?.didTapDetailView(eventId: events[idx].id)
    }

    func eventSheetDidTapHideToday(_ view: EventSheetView) {
        TDTokenManager.shared.markEventSheetHiddenForToday()
        coordinator?.finish(by: .sheet(completion: {}))
    }

    func eventSheetDidTapClose(_ view: EventSheetView) {
        coordinator?.finish(by: .sheet(completion: {}))
    }
}
