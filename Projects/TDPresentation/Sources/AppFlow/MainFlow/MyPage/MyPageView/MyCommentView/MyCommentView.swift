import TDDesign
import UIKit

final class MyCommentView: BaseView {
    private let commentLabel = TDLabel(labelText: "작성한 댓글", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800)

    private let commentCountLabel = TDLabel(labelText: "0개", toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral500)
    
    private(set) lazy var socialFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let emptyView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let emptyLabel = TDLabel(
        labelText: "작성한 댓글이 없어요.",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    override func addview() {
        addSubview(commentLabel)
        addSubview(commentCountLabel)
        addSubview(socialFeedCollectionView)
        addSubview(emptyView)
        emptyView.addSubview(emptyLabel)
    }
    
    override func configure() {
        backgroundColor = TDColor.Neutral.neutral100
        socialFeedCollectionView.register(with: MyCommentCell.self)
    }
    
    override func layout() {
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(16)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentLabel)
            make.leading.equalTo(commentLabel.snp.trailing).offset(6)
        }
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(socialFeedCollectionView)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(emptyView)
        }
    }
    
    public func configureCommentCountLabel(count: Int) {
        if count == 0 {
            emptyView.isHidden = false
            socialFeedCollectionView.isHidden = true
        } else {
            emptyView.isHidden = true
            socialFeedCollectionView.isHidden = false
        }
        commentCountLabel.setText("\(count)개")
    }
}

private extension MyCommentView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        
        let edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(0),
            bottom: .fixed(itemPadding)
        )
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            itemEdgeSpacing: edgeSpacing,
            groupSize: groupSize
        )
    }
}
