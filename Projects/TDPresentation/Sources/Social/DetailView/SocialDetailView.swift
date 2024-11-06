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
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension SocialDetailView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            groupSize: groupSize
        )
    }
    
}
