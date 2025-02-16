import SnapKit
import TDDesign
import UIKit

final class SocialDetailView: BaseView, UITextViewDelegate {
    private(set) lazy var detailCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.Neutral.neutral200
        $0.bounces = false
        $0.isUserInteractionEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
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
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

private extension SocialDetailView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1000)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1000)
        )

        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            groupSize: groupSize
        )
    }
}
