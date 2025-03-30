//
//  MyPageView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/7/25.
//

import UIKit
import SnapKit
import TDDesign

final class MyPageView: BaseView {
    private let scrollView = CustomScrollView()
    private let containerView = UIView()
    let profileView = MyPageProfileView()
    private let socialButtonView = MyPageSocialButtonView()
    private let menuView: UICollectionView = {
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
    
    // MARK: - Default Methods
    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.delegate = self
        [profileView, socialButtonView, menuView, logoutButton].forEach { containerView.addSubview($0) }
    }
    
    override func configure() {
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        menuView.delegate = self
        menuView.dataSource = self
        menuView.register(
            MyPageMenuCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyPageMenuCollectionHeaderView.identifier
        )
        menuView.register(
            MyPageMenuCollectionViewCell.self,
            forCellWithReuseIdentifier: MyPageMenuCollectionViewCell.identifier
        )
        menuView.register(
            MyPageMenuCollectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MyPageMenuCollectionFooterView.identifier
        )
        menuView.reloadData()
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
        
        menuView.snp.makeConstraints {
            $0.top.equalTo(socialButtonView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(LayoutConstants.randomHeight)
            $0.bottom.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(LayoutConstants.footerPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.sectionHorizontalInset)
            $0.height.equalTo(48)
        }
    }
}

extension MyPageView: UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return Constants.mockDataSource.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Constants.mockDataSource[section].value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMenuCollectionViewCell.identifier, for: indexPath
        ) as? MyPageMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let sectionData = Constants.mockDataSource[indexPath.section]
        let item = sectionData.value[indexPath.item]
        cell.configure(with: item)
        
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
            let sectionData = Constants.mockDataSource[indexPath.section]
            header.configure(with: sectionData.key)
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
        return CGSize(
            width: collectionView.bounds.width - LayoutConstants.sectionHorizontalInset * 2,
            height: LayoutConstants.customCellHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: LayoutConstants.sectionHeaderHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: LayoutConstants.sectionFooterHeight
        )
    }
}

extension MyPageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = menuView.contentSize.height
        if contentHeight > 0 {
            menuView.snp.updateConstraints {
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
    
    enum Constants {
        static let mockDataSource: [(key: String, value: [String])] = [
            ("계정 관리", ["알림 설정", "작성 글 관리", "나의 댓글", "차단 관리"]),
            ("고객센터", ["자주 묻는 질문", "문의하기", "문의 내역", "공지사항", "토덕 이용 가이드"]),
            ("서비스 약관", ["이용 약관", "개인정보 처리방침"])
        ]
    }
}
