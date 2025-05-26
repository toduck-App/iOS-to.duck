import UIKit
import SnapKit

import TDDesign

final class MyPageMenuCollectionViewCell: UICollectionViewCell {
    private let textLabel = TDLabel(
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
    
    func configure(with title: String) {
        textLabel.setText(title)
    }
}

// MARK: - Private Methods
private extension MyPageMenuCollectionViewCell {
    func setupViews() {
        addSubview(textLabel)
    }
    
    func setupLayoutConstraints() {
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}
