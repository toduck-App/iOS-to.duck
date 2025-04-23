import TDDesign
import UIKit

final class SocialReportView: BaseView {
    private let titleLabel = TDLabel(toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)
    
    private(set) lazy var tableView = UITableView().then {
        $0.register(SocialReportTableViewCell.self, forCellReuseIdentifier: SocialReportTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func setupView() {
        backgroundColor = TDColor.baseWhite
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    func setTitle(_ title: String) {
        titleLabel.setText("\(title)을 신고하는 이유를 알려주세요.")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
