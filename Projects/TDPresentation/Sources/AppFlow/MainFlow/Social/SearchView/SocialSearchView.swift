import SnapKit
import TDDesign
import Then
import UIKit

// MARK: - SearchView

final class SocialSearchView: BaseView {
    private(set) var cancleButton = UIButton().then {
        $0.setImage(TDImage.X.x2Medium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = TDColor.Neutral.neutral800
    }
    
    private(set) var backButton = UIButton().then {
        $0.setImage(TDImage.Direction.leftMedium.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = TDColor.Neutral.neutral800
    }

    private(set) var searchBar = UISearchBar().then {
        $0.searchTextField.textColor = TDColor.Neutral.neutral800
        $0.searchTextField.backgroundColor = TDColor.Neutral.neutral50
        $0.searchTextField.clearButtonMode = .never
        $0.searchTextField.autocorrectionType = .no
        $0.searchTextField.spellCheckingType = .no
        $0.searchTextField.returnKeyType = .search
        let placeholderText = "제목이나 키워드를 검색해보세요."
        let placeholderColor = TDColor.Neutral.neutral500
        let placeholderFont = TDFont.boldBody2.font

        $0.searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: placeholderFont
            ]
        )
//        if let leftImageView = $0.searchTextField.leftView as? UIImageView {
//            let image = leftImageView.image?.withRenderingMode(.alwaysTemplate)
//            leftImageView.image = image
//            leftImageView.tintColor = TDColor.Neutral.neutral400
//        }
        $0.searchTextField.leftView = nil
        $0.searchTextField.leftViewMode = .never
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

    override func configure() {
        super.configure()
        backgroundColor = TDColor.baseWhite
    }

    override func addview() {
        super.addview()
        addSubview(keywordCollectionView)
    }

    override func layout() {
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }

    func showKeyboard() {
        searchBar.becomeFirstResponder()
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
}

extension SocialSearchView {
    enum KeywordSection: Int, CaseIterable {
        case recent
        case popular

        var title: String {
            switch self {
            case .recent:
                "최근 검색어"
            case .popular:
                "인기 검색어"
            }
        }

        var showRemoveButton: Bool {
            self == .recent
        }
    }
}
