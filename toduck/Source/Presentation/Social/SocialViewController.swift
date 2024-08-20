//
//  SocialViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit

class SocialViewController: BaseViewController<SocialView>, TDSheetPresentation {
    
    private let searchBar = UISearchBar()
    private var filteredPosts: [Post] = []
    private var isSearchActive: Bool = false
    
    let chipTexts = ["집중력", "기억력", "충동", "불안", "수면"]
    let posts: [Post] = Post.dummy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupSearchBar()
        
    }
    
    private func setupSearchBar() {
        // 서치 바 설정
        searchBar.placeholder = "제목이나 키워드를 입력해보세요."
        searchBar.searchTextField.font = TDFont.mediumBody2.font
        searchBar.setImage(UIImage(named: "search_back"), for: .search, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 16, vertical: 0), for: .search)
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
    }
    
    @objc private func setupNavigationBar() {
        self.navigationItem.titleView = nil
        // 네비게이션 바 왼쪽에 "소셜" 텍스트 추가
        let leftLabel = TDLabel(labelText: "소셜",toduckFont: .boldHeader4)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        
        // 네비게이션 바 오른쪽에 돋보기 버튼 추가
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchButton))
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func didTapSearchButton() {
        // 돋보기 버튼 클릭 시 서치 바를 네비게이션 바에 추가
        self.navigationItem.titleView = searchBar
        self.navigationItem.leftBarButtonItem = nil
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(setupNavigationBar))
    }
    
    override func configure() {
        layoutView.socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
        layoutView.socialFeedCollectionView.dataSource = self
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(chipTexts)
    }
}

extension SocialViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercasedSearchText = searchText.lowercased()
        if lowercasedSearchText.isEmpty {
            isSearchActive = false
            filteredPosts.removeAll()
        } else {
            isSearchActive = true
            filteredPosts = posts.filter { $0.contentText.lowercased().contains(lowercasedSearchText) }
        }
        layoutView.socialFeedCollectionView.reloadData()
    }
}
extension SocialViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        print("[LOG] 현재 Select 한 Chip: \(chipText) , Index = : \(index)")
    }
}

extension SocialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchActive ? filteredPosts.count : posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let post = isSearchActive ? filteredPosts[indexPath.item] : posts[indexPath.item]
        cell.configure(with: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[LOG] Clicked")
    }
}
