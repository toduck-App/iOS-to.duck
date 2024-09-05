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
    var posts: [Post] = Post.dummy
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        layoutView.socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
        layoutView.socialFeedCollectionView.dataSource = self
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(chipTexts)
    }
    
    override func addView() {
        
    }
    
    override func layout() {
        
    }
    
    override func binding() {
        
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
        cell.socialFeedCellDelegate = self
        cell.configure(with: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[LOG] Clicked")
    }
}

extension SocialViewController: SocialFeedCollectionViewCellDelegate{
    func didTapNickname(_ cell: SocialFeedCollectionViewCell) {
        
    }

    func didTapMoreButton(_ cell: SocialFeedCollectionViewCell) {
    
    }
    
    func didTapCommentButton(_ cell: SocialFeedCollectionViewCell) {
        print("[LOG] Comment Button Clicked")
    }

    func didTapShareButton(_ cell: SocialFeedCollectionViewCell) {
        print("[LOG] Share Button Clicked")
    }

    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell) {
        print("[LOG] Like Button Clicked")
        guard let indexPath = layoutView.socialFeedCollectionView.indexPath(for: cell) else {
            return
        }
        
        let postIndex = indexPath.item
        posts[postIndex].isLike.toggle()
        cell.configure(with: posts[postIndex])
    }
}
