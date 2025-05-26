import FittedSheets
import TDDomain
import UIKit

final class SocialReportViewController: BaseViewController<SocialReportView> {
    weak var coordinator: SocialReportCoordinator?
    private var dataSource: [ReportType] = ReportType.allCases
    
    init(reportViewType: ReportViewType) {
        super.init()
        switch reportViewType {
        case .post:
            layoutView.setTitle("게시글")
        case .comment:
            layoutView.setTitle("댓글")
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView.tableView.delegate = self
        layoutView.tableView.dataSource = self
    }
}

extension SocialReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SocialReportTableViewCell.identifier, for: indexPath) as! SocialReportTableViewCell
        let reportType = dataSource[indexPath.row]
        cell.configure(with: reportType.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = dataSource[indexPath.row]
        coordinator?.didTapReportType(selectedType)
    }
}
