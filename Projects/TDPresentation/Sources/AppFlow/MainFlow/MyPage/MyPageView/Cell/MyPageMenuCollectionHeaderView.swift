import UIKit
import SnapKit

import TDDesign

final class MyPageMenuCollectionHeaderView: UICollectionReusableView {
    private let titleLabel = TDLabel(
        toduckFont: .mediumCaption1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.setText(title)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

// MARK: - Private Methods
private extension MyPageMenuCollectionHeaderView {
    func setupView() {
        addSubview(titleLabel)
    }
    
    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(LayoutConstants.titleLabelPadding)
        }
    }
}

// MARK: - Constants
private extension MyPageMenuCollectionHeaderView {
    enum LayoutConstants {
        static let titleLabelPadding: CGFloat = 16
    }
}
