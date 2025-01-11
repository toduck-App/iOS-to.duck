import FittedSheets
import UIKit

final class SocialReportViewController: BaseViewController<SocialReportView> {
    weak var coordinator: SocialReportCoordinator?
    private var dataSource: [ReportType] = ReportType.allCases

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
        cell.configure(with: reportType.rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = dataSource[indexPath.row]
        coordinator?.didTapReportType(selectedType)
    }
}
