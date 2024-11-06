import SnapKit
import TDDesign
import Then
import UIKit

final class SocialListView: BaseView {
    private let chipType: TDChipType = TDChipType(
        backgroundColor: .init(
            activeColor: TDColor.Primary.primary500,
            inActiveColor: TDColor.baseWhite
        ),
        fontColor: .init(
            activeColor: TDColor.baseWhite,
            inActiveColor: TDColor.Neutral.neutral700
        ),
        cornerRadius: 8,
        height: 33
    )
    
    private let segmentedControl = TDSegmentedController(
        items: ["전체", "주제별"]
    )
    
    private(set) lazy var chipCollectionView = TDChipCollectionView(
        chipType: chipType,
        hasAllSelectChip: false,
        isMultiSelect: false
    )
    
    private(set) lazy var socialFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    ).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private let dropDownDataSource: [SocialSortType] = [
        .recent,
        .comment,
        .sympathy
    ]
    
    private(set) lazy var dropDownAnchorView = SocialListDropdownView(
        title: dropDownDataSource[0].rawValue
    )
    
    private(set) lazy var dropDownHoverView = TDDropdownHoverView(
        anchorView: dropDownAnchorView,
        selectedOption: dropDownDataSource[0].rawValue,
        layout: .trailing,
        width: 100
    )
    
    private(set) lazy var refreshControl = UIRefreshControl().then {
        $0.tintColor = .systemGray
    }
    private let loadingView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    override func layout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(133)
            make.height.equalTo(43)
        }
        
        dropDownAnchorView.snp.makeConstraints { make in
            make.height.equalTo(43)
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(65)
        }
        
        chipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(33)
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.equalTo(segmentedControl.snp.leading).offset(10)
            make.trailing.equalToSuperview().inset(16)
        }
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(chipCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(socialFeedCollectionView)
        }
    }
    
    override func configure() {
        backgroundColor = .white
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
    }
    
    override func addview() {
        [segmentedControl, dropDownHoverView, chipCollectionView, socialFeedCollectionView, loadingView].forEach {
            addSubview($0)
        }
    }
    
    override func binding() {
        
    }
}

// MARK: External Method
extension SocialListView {
    func showLoadingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
            UIView.animate(withDuration: 0.5) {
                self.loadingView.alpha = 1
            }
        }
    }
    
    func showFinishView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
            UIView.animate(withDuration: 0.5) {
                self.loadingView.alpha = 0
            }
        }
    }
    
    func showEmptyView() {
        
    }
    
    func showErrorView() {
        
    }
    
    func hideDropdown() {
        dropDownHoverView.hideDropDown()
    }
}

private extension SocialListView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let groupPadding: CGFloat = 16
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
            top: .fixed(itemPadding),
            trailing: .fixed(0),
            bottom: .fixed(itemPadding)
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
