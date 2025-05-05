import SnapKit
import TDDesign
import UIKit

final class MyPageView: BaseView {
    private var sections: [MenuSection] = []
    var didSelectMenuItem: ((MenuItem) -> Void)?
    
    private let scrollView = CustomScrollView()
    private let containerView = UIView()
    let profileView = MyPageProfileView()
    let socialButtonView = MyPageSocialButtonView()
    private let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = LayoutConstants.sectionItemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: LayoutConstants.sectionHorizontalInset,
            bottom: 0,
            right: LayoutConstants.sectionHorizontalInset
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    let logoutButton = TDBaseButton(
        title: "로그아웃",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldBody1.font
    )
    let deleteAccountButton = TDBaseButton(
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral500,
        font: TDFont.regularBody2.font
    )
    
    // MARK: - Default Methods

    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.delegate = self
        [profileView, socialButtonView, menuCollectionView, logoutButton, deleteAccountButton].forEach { containerView.addSubview($0) }
    }
    
    override func configure() {
        containerView.backgroundColor = TDColor.baseWhite
        profileView.backgroundColor = TDColor.baseWhite
        socialButtonView.backgroundColor = TDColor.baseWhite
        menuCollectionView.backgroundColor = TDColor.baseWhite
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(
            MyPageMenuCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyPageMenuCollectionHeaderView.identifier
        )
        menuCollectionView.register(
            MyPageMenuCollectionViewCell.self,
            forCellWithReuseIdentifier: MyPageMenuCollectionViewCell.identifier
        )
        menuCollectionView.register(
            MyPageMenuCollectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MyPageMenuCollectionFooterView.identifier
        )
        menuCollectionView.reloadData()
        
        let underlineTitle = NSAttributedString(
            string: "회원탈퇴",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: TDColor.Neutral.neutral500,
                .font: TDFont.regularBody2.font
            ]
        )
        deleteAccountButton.setAttributedTitle(underlineTitle, for: .normal)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        profileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(
                LayoutConstants.contentViewHeight +
                    LayoutConstants.containerVerticalPadding * 2
            )
            $0.width.equalToSuperview()
        }
        
        socialButtonView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(LayoutConstants.menuViewHeight)
            $0.width.equalToSuperview()
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(socialButtonView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(LayoutConstants.randomHeight)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(menuCollectionView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.sectionHorizontalInset)
            $0.height.equalTo(48)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.sectionHorizontalInset)
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    func setMenuSections(_ sections: [MenuSection]) {
        self.sections = sections
        menuCollectionView.reloadData()
    }
}

extension MyPageView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMenuCollectionViewCell.identifier,
            for: indexPath
        ) as! MyPageMenuCollectionViewCell

        let item = sections[indexPath.section].items[indexPath.item]
        cell.configure(with: item.title)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyPageMenuCollectionHeaderView.identifier,
                for: indexPath
            ) as? MyPageMenuCollectionHeaderView else {
                return UICollectionReusableView()
            }
            let sectionData = sections[indexPath.section].header
            header.configure(with: sectionData)
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyPageMenuCollectionFooterView.identifier,
                for: indexPath
            ) as? MyPageMenuCollectionFooterView else {
                return UICollectionReusableView()
            }
            return footer
        }
        return UICollectionReusableView()
    }
}

extension MyPageView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width - LayoutConstants.sectionHorizontalInset * 2,
            height: LayoutConstants.customCellHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: LayoutConstants.sectionHeaderHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: LayoutConstants.sectionFooterHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.item]
        didSelectMenuItem?(item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MyPageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = menuCollectionView.contentSize.height
        if contentHeight > 0 {
            menuCollectionView.snp.updateConstraints {
                $0.height.equalTo(contentHeight)
            }
        }
    }
}

// MARK: - Constants

private extension MyPageView {
    enum LayoutConstants {
        static let sectionHorizontalInset: CGFloat = 16
        static let sectionItemSpacing: CGFloat = 6
        static let sectionHeaderHeight: CGFloat = 50
        static let sectionFooterHeight: CGFloat = 20
        static let customCellHeight: CGFloat = 41
        static let containerVerticalPadding: CGFloat = 12
        static let contentViewHeight: CGFloat = 80
        static let footerPadding: CGFloat = 20
        static let menuViewHeight: CGFloat = 110
        static let randomHeight: CGFloat = 1000
    }
}
