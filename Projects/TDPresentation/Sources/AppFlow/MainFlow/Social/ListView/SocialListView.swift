import SnapKit
import TDDesign
import Then
import UIKit

final class SocialListView: BaseView {
    private(set) var searchButton = UIButton(type: .custom).then {
        $0.setImage(TDImage.searchMedium, for: .normal)
    }
    
    private(set) var searchView = SocialSearchView().then {
        $0.isHidden = true
    }
    
    private let chipType: TDChipType = .init(
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
    
    private(set) var segmentedControl = TDSegmentedControl(
        items: ["전체", "주제별"]
    )
    
    private let segmentedControlBottomLine = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral200
    }
    
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
    
    private let dropDownDataSource: [SocialSortType] = SocialSortType.allCases
    
    private(set) lazy var dropDownAnchorView = SocialListDropdownView(
        title: dropDownDataSource[0].rawValue
    )
    
    private(set) lazy var dropDownHoverView = TDDropdownHoverView(
        anchorView: dropDownAnchorView,
        selectedOption: dropDownDataSource[0].rawValue,
        layout: .trailing,
        width: 110
    ).then {
        $0.dataSource = dropDownDataSource.map(\.dropdownItem)
    }
    
    private(set) lazy var addPostButton = TDBaseButton(
        title: "글쓰기",
        image: TDImage.addSmall.withRenderingMode(.alwaysTemplate).withTintColor(.white),
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 25,
        font: TDFont.boldHeader4.font
    )
    
    private(set) lazy var refreshControl = UIRefreshControl().then {
        $0.tintColor = .systemGray
    }

    private let loadingView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    private var chipCollectionViewHeightConstraint: Constraint?
    private var chipCollectionViewTopConstraint: Constraint?
    private var socialFeedCollectionViewTopConstraint: Constraint?
    
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
            chipCollectionViewTopConstraint = make.top.equalTo(segmentedControl.snp.bottom).offset(0).constraint
            make.leading.equalTo(segmentedControl.snp.leading).offset(10)
            make.trailing.equalToSuperview().inset(16)
            chipCollectionViewHeightConstraint = make.height.equalTo(0).constraint
        }

        socialFeedCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            socialFeedCollectionViewTopConstraint = make.top.equalTo(chipCollectionView.snp.bottom).offset(0).constraint
        }
        
        addPostButton.snp.makeConstraints { make in
            make.width.equalTo(104)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }

        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(socialFeedCollectionView)
        }
        
        searchView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        segmentedControlBottomLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(segmentedControl.snp.bottom)
            make.height.equalTo(1)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
    }
    
    override func addview() {
        [segmentedControl, dropDownHoverView, chipCollectionView, socialFeedCollectionView, addPostButton, loadingView, searchView, segmentedControlBottomLine].forEach {
            addSubview($0)
        }
    }
}

// MARK: External Method

extension SocialListView {
    func showEndRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func showLoadingView() {
        DispatchQueue.main.async {
            self.loadingView.alpha = 1
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
    
    func showSearchView() {
        segmentedControlBottomLine.isHidden = true
        searchView.isHidden = false
    }
    
    func hideSearchView() {
        searchView.isHidden = true
        segmentedControlBottomLine.isHidden = false
        searchView.hideKeyboard()
    }
    
    func clearSearchText() {
        searchView.searchBar.text = nil
    }
    
    func showEmptyView() {}
    
    func updateLayoutForSegmentedControl(index: Int) {
        chipCollectionView.isHidden = false
        let animationIndex = index
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            if animationIndex == 0 {
                self.chipCollectionView.alpha = 0.3
                self.chipCollectionViewHeightConstraint?.update(offset: 0)
                self.chipCollectionViewTopConstraint?.update(offset: 0)
                self.socialFeedCollectionViewTopConstraint?.update(offset: 0)
            } else {
                self.chipCollectionView.alpha = 1
                self.chipCollectionViewHeightConstraint?.update(offset: 33)
                self.chipCollectionViewTopConstraint?.update(offset: 16)
                self.socialFeedCollectionViewTopConstraint?.update(offset: 10)
            }
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            if animationIndex == 0 {
                self.chipCollectionView.isHidden = true
            } else {
                self.chipCollectionView.isHidden = false
            }
        }
        animator.startAnimation()
    }
}

// MARK: Layout

private extension SocialListView {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let groupPadding: CGFloat = 16
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
