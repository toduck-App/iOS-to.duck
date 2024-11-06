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
        backgroundColor = TDColor.baseWhite
        detailCollectionView.register(with: SocialDetailPostCell.self)
        detailCollectionView.register(with: SocialDetailCommentCell.self)
    }
    
    override func layout() {
        detailCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension SocialDetailView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let groupPadding: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        
        let edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(0),
            bottom: .fixed(12)
        )
        
        let groupInset = NSDirectionalEdgeInsets(
            top: 0,
            leading: groupPadding,
            bottom: 0,
            trailing: groupPadding
        )
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            itemEdgeSpacing: edgeSpacing,
            groupSize: groupSize,
            groupInset: groupInset
        )
    }
    
}
