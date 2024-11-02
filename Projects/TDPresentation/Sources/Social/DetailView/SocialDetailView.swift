import SnapKit
import TDDesign
import UIKit

final class SocialDetailView: BaseView {
    private(set) lazy var detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    override func addview() {
        addSubview(detailCollectionView)
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral100
        detailCollectionView.register(with: SocialFeedCollectionViewCell.self)
        detailCollectionView.register(with: SocialDetailCommentCell.self)
    }
    
    override func layout() {
        detailCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private extension SocialDetailView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let horizontalSpacing: CGFloat = 16
        let verticalSpacing: CGFloat = 12
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let itemEdgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(horizontalSpacing),
            top: .fixed(verticalSpacing),
            trailing: .fixed(horizontalSpacing),
            bottom: .fixed(verticalSpacing)
        )
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            itemEdgeSpacing: itemEdgeSpacing,
            groupSize: groupSize
        )
    }
}
