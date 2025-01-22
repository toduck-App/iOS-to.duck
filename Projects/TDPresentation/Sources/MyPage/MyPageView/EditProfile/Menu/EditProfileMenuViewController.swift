//
//  EditProfileMenuViewController.swift
//  TDPresentation
//
//  Created by 정지용 on 1/15/25.
//

import UIKit
import SnapKit

final class EditProfileMenuViewController: UICollectionViewController {
    weak var coordinator: EditProfileMenuCoordinator?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: LayoutConstants.collectionViewTopPadding,
            left: LayoutConstants.horizontalInset,
            bottom: 0,
            right: LayoutConstants.horizontalInset
        )
        layout.minimumLineSpacing = LayoutConstants.cellSpacing
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "프로필",
            leftButtonAction: UIAction(handler: { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            })
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension EditProfileMenuViewController {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.register(
            MyPageMenuCollectionViewCell.self,
            forCellWithReuseIdentifier: MyPageMenuCollectionViewCell.identifier
        )
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension EditProfileMenuViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Constants.mockDataSource.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageMenuCollectionViewCell.identifier,
            for: indexPath
        ) as? MyPageMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = Constants.mockDataSource[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EditProfileMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(
            width: width - LayoutConstants.horizontalInset * 2,
            height: LayoutConstants.cellHeight
        )
    }
}

// MARK: - Constants
private extension EditProfileMenuViewController {
    enum LayoutConstants {
        static let cellSpacing: CGFloat = 12
        static let cellHeight: CGFloat = 41
        static let horizontalInset: CGFloat = 16
        static let collectionViewTopPadding: CGFloat = 20
    }
    
    enum Constants {
        static let mockDataSource: [String] = [
            "프로필 수정",
            "회원 정보 수정",
            "비밀번호 수정",
            "로그아웃",
            "회원 탈퇴"
        ]
    }
}
