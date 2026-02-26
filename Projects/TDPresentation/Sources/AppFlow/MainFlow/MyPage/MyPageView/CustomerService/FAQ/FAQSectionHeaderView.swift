import SnapKit
import TDDesign
import UIKit

final class FAQSectionHeaderView: UITableViewHeaderFooterView {

    private let titleLabel = TDLabel(
        toduckFont: .boldHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(16)
        }
    }

    func configure(title: String) {
        titleLabel.setText(title)
    }
}
