//
//  SocialViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit
import Then
import SnapKit

class SocialViewController: UIViewController, TDSheetPresentation {
    private(set) lazy var chipCollectionView = TDChipCollectionView(chipType: .capsule, hasAllSelectChip: false)
    private(set) lazy var chipCollectionView2 = TDChipCollectionView(chipType: .roundedRectangle, hasAllSelectChip: true)
    private(set) lazy var socialFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
        $0.backgroundColor = TDColor.baseWhite
        
    }
    
    let chipTexts = ["집중력", "기억력", "충동", "불안", "수면", "test", "test2", "test3", "test4", "test5"]
    let posts : [Post] = Post.dummy
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.socialFeedCollectionView.dataSource = self
        self.socialFeedCollectionView.delegate = self
    }
}

extension SocialViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        print("[LOG] 현재 Select 한 Chip: \(chipText) , Index = : \(index)")
    }
}

extension SocialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let post = posts[indexPath.item]
        cell.configure(with: post)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[LOG] Clicked")
    }
}

private extension SocialViewController {
    
    private func setupUI() {
        //MARK: - layout 싹 다 다시 잡아야함
        view.addSubview(chipCollectionView)
        view.addSubview(chipCollectionView2)
        view.addSubview(socialFeedCollectionView)
        chipCollectionView.chipDelegate = self
        chipCollectionView2.chipDelegate = self
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
        chipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        chipCollectionView2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(chipCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        chipCollectionView.setChips(chipTexts)
        chipCollectionView2.setChips(chipTexts)
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chipCollectionView2.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
    }
}

private extension SocialViewController {
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
