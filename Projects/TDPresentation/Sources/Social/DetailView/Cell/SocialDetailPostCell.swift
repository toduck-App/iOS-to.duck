import SnapKit
import TDDesign
import TDDomain
import UIKit

final class SocialDetailPostCell: UICollectionViewCell {
    private let emptyView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral800
    }
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(with post: Post) { }
}

// MARK: Layout

private extension SocialDetailPostCell {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        contentView.addSubview(emptyView)
    }
    
    func setupConstraints() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
