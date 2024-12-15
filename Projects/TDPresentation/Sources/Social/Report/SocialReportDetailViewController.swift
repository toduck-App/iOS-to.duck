import UIKit

final class SocialReportDetailViewController: BaseViewController<SocialReportDetailView> {
    weak var coordinator: SocialReportCoordinator?
    private let reason: ReportType

    init(reason: ReportType) {
        self.reason = reason
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView.setReason(reason: reason)
        layoutView.reportButton.addTarget(self, action: #selector(reportAction), for: .touchUpInside)
    }

    @objc private func reportAction() {
        coordinator?.didTapReport()
    }
}
