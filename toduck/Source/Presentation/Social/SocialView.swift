//
//  SocialView.swift
//  toduck
//
//  Created by 승재 on 8/20/24.
//
import SnapKit
import UIKit

class SocialView: BaseView {
    private(set) lazy var chipCollectionView = TDChipCollectionView(chipType: .roundedRectangle, hasAllSelectChip: true)
    private(set) lazy var socialFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
        $0.backgroundColor = TDColor.baseWhite
    }
    private(set) var tempView = UIButton().then {
        $0.setTitle("최신순", for: .normal)
        $0.setTitleColor(TDColor.Neutral.neutral700, for: .normal)
    }
    
    override func layout() {
        tempView.snp.makeConstraints { make in
            make.width.equalTo(65)
            make.height.equalTo(30)
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
        }
        
        chipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(33)
            make.top.equalTo(tempView)
            make.leading.equalTo(tempView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(chipCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configure() {
        backgroundColor = .white
    }
    
    override func addview() {
        [tempView, chipCollectionView, socialFeedCollectionView].forEach {
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
