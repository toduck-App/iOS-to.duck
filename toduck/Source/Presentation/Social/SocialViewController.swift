//
//  SocialViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit

class SocialViewController: BaseViewController<SocialView>, TDSheetPresentation {
    

    private var filteredPosts: [Post] = []
    private var isSearchActive: Bool = false
    
    let chipTexts = ["집중력", "기억력", "충동", "불안", "수면", "test", "test2", "test3", "test4", "test5"]
    let posts: [Post] = Post.dummy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "제목이나 키워드를 입력해보세요."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    override func configure() {
        layoutView.socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
        layoutView.socialFeedCollectionView.dataSource = self
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(chipTexts)
    }
}

extension SocialViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        if searchText.isEmpty {
            isSearchActive = false
            filteredPosts.removeAll()
        } else {
            isSearchActive = true
            filteredPosts = posts.filter { $0.contentText.lowercased().contains(searchText) }
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
