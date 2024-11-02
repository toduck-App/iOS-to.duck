import TDDesign
import TDDomain
import UIKit

final class SocialDetailCommentCell: UICollectionViewCell {
    private let emptyView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral500
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
    
    func configure(with comment: Comment) {}
}

// MARK: Layout

private extension SocialDetailCommentCell {
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
