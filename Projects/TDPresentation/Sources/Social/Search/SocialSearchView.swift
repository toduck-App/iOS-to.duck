import SnapKit
import TDDesign
import Then
import UIKit

// MARK: - SearchView

final class SocialSearchView: BaseView {
    private(set) var cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(TDColor.Neutral.neutral800, for: .normal)
        $0.titleLabel?.font = TDFont.mediumBody2.font
    }
    
    private(set) var searchBar = UISearchBar().then {
        $0.placeholder = "제목이나 키워드를 검색해보세요."
        $0.searchTextField.textColor = TDColor.Neutral.neutral800
        $0.searchTextField.backgroundColor = TDColor.Neutral.neutral50
        $0.searchTextField.font = TDFont.boldBody2.font
        $0.searchTextField.clearButtonMode = .never
        $0.searchTextField.autocapitalizationType = .none
        $0.searchTextField.autocorrectionType = .yes
        $0.searchTextField.returnKeyType = .search
    }
    
    private(set) lazy var keywordCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeFlowLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
        $0.isScrollEnabled = false
        $0.register(with: CancleTagCell.self)
        $0.register(with: TagCell.self)
        $0.register(
            KeywordSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: KeywordSectionHeaderView.identifier
        )
    }
    
    private(set) lazy var postCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCompositionLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
        $0.isHidden = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(with: SocialFeedCollectionViewCell.self)
    }
    
    override func configure() {
        super.configure()
        backgroundColor = TDColor.baseWhite
    }
    
    override func addview() {
        super.addview()
        addSubview(keywordCollectionView)
        addSubview(postCollectionView)
    }
    
    override func layout() {
        super.layout()
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func showKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    func showRecommendView() {
        keywordCollectionView.isHidden = false
        postCollectionView.isHidden = true
    }
    
    func showResultView() {
        keywordCollectionView.isHidden = true
        postCollectionView.isHidden = false
    }
    
    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 28,
            right: 0
        )
        return layout
    }
    
    private func makeCompositionLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
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
