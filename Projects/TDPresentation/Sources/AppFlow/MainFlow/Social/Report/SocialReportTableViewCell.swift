import SnapKit
import TDDesign
import UIKit

final class SocialReportTableViewCell: UITableViewCell {
    private let reasonLabel = TDLabel(toduckFont: .boldHeader5, toduckColor: TDColor.Neutral.neutral600)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(reasonLabel)
        reasonLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func configure(with reason: String) {
        reasonLabel.setText(reason)
    }
}
