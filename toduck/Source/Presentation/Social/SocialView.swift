//
//  SocialView.swift
//  toduck
//
//  Created by 승재 on 8/20/24.
//

import Foundation
import SnapKit
import UIKit

class SocialView: BaseView {
    private(set) lazy var chipCollectionView = TDChipCollectionView(chipType: .roundedRectangle, hasAllSelectChip: true)
    private(set) lazy var socialFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    override func layout() {

        chipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        socialFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chipCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    override func configure() {
        backgroundColor = .white
    }
    override func addview() {
        [chipCollectionView,socialFeedCollectionView].forEach {
            addSubview($0)
        }
    }
    override func binding() {
        
    }
    
}

private extension SocialView{
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let groupPadding: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
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
