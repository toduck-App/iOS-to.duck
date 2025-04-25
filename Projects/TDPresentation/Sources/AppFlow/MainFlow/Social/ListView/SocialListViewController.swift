import Combine
import TDCore
import TDDesign
import TDDomain
import UIKit

final class SocialListViewController: BaseViewController<SocialListView> {
    weak var coordinator: SocialListCoordinator?
    private let viewModel: SocialListViewModel!
    private let input = PassthroughSubject<SocialListViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var datasource: UICollectionViewDiffableDataSource<Int, Post.ID>?
    private var keywordDataSource: UICollectionViewDiffableDataSource<SocialSearchView.KeywordSection, Keyword>!
    
    init(viewModel: SocialListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.fetchPosts)
    }
    
    private func setupDefaultNavigationBar() {
        // 좌측 네비게이션 바 버튼 설정 (캘린더 + 로고)
        let tomatoButton = UIButton(type: .custom)
        tomatoButton.setImage(TDImage.Diary.navigationImage, for: .normal)
        tomatoButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapHomeTomatoIcon()
        }, for: .touchUpInside)
        
        let toduckLogoImageView = UIImageView(image: TDImage.toduckLogo)
        toduckLogoImageView.contentMode = .scaleAspectFit
        
        let leftBarButtonItems = [
            UIBarButtonItem(customView: tomatoButton),
            UIBarButtonItem(customView: toduckLogoImageView)
        ]
        
        navigationItem.leftBarButtonItems = leftBarButtonItems
        
        // 우측 버튼 설정 (검색 버튼)
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutView.searchButton)
    }
    
    private func setupNavigationSearchBar() {
        navigationItem.leftBarButtonItems = nil
        navigationItem.titleView = layoutView.searchView.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutView.searchView.cancleButton)
    }
    
    override func configure() {
        layoutView.searchButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.showSearchView()
            self?.setupNavigationSearchBar()
            self?.input.send(.loadKeywords)
        }, for: .touchUpInside)
        
        layoutView.searchView.cancleButton.addAction(UIAction {
            [weak self] _ in
            self?.layoutView.hideSearchView()
            self?.layoutView.clearSearchText()
            self?.setupDefaultNavigationBar()
            self?.input.send(.clearSearch)
        }, for: .touchUpInside)
        
        layoutView.searchView.searchBar.delegate = self
        layoutView.searchView.keywordCollectionView.delegate = self
        layoutView.searchView.keywordCollectionView.dataSource = keywordDataSource
        layoutView.socialFeedCollectionView.delegate = self
        layoutView.socialFeedCollectionView.refreshControl = layoutView.refreshControl
        layoutView.chipCollectionView.chipDelegate = self
        layoutView.chipCollectionView.setChips(PostCategory.allCases.map { TDChipItem(title: $0.title) })
        setupDataSource()
        layoutView.dropDownHoverView.delegate = self
        layoutView.addPostButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        layoutView.refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        layoutView.segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl), for: .valueChanged)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .fetchPosts(let posts):
                    self?.layoutView.showFinishView()
                    self?.applySnapshot(posts)
                case .likePost(let post):
                    self?.updateSnapshot(post)
                case .failure(let message):
                    self?.showErrorAlert(errorMessage: message)
                case .searchPosts(let posts):
                    // TODO: Search
                    self?.layoutView.showFinishView()
                    self?.layoutView.hideSearchView()
                    self?.applySnapshot(posts)
                case .updateKeywords:
                    self?.applyKeywordSnapshot()
                }
            }.store(in: &cancellables)
    }
}

extension SocialListViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        input.send(.chipSelect(at: index))
    }
}

extension SocialListViewController: UICollectionViewDelegate {
    private func setupDataSource() {
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { collectionView, indexPath, postID in
            guard let post = self.viewModel.posts.first(where: { $0.id == postID }) else { return UICollectionViewCell() }
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.socialFeedCellDelegate = self
            let highlight: String? = self.viewModel.isSearching ? self.viewModel.searchTerm : nil
                        
            cell.configure(with: post, highlightTerm: highlight)
            
            return cell
        })
        
        keywordDataSource = UICollectionViewDiffableDataSource<SocialSearchView.KeywordSection, Keyword>(
            collectionView: layoutView.searchView.keywordCollectionView
        ) { [weak self] collectionView, indexPath, keyword in
            guard let section = SocialSearchView.KeywordSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .recent:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CancleTagCell.identifier,
                    for: indexPath
                ) as? CancleTagCell else {
                    return UICollectionViewCell()
                }
                cell.configure(tag: keyword.word)
                cell.delegate = self
                return cell
                
            case .popular:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagCell.identifier,
                    for: indexPath
                ) as? TagCell else {
                    return UICollectionViewCell()
                }
                cell.configure(tag: keyword.word)
                return cell
            }
        }
        
        keywordDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let section = SocialSearchView.KeywordSection(rawValue: indexPath.section),
                  let header = collectionView.dequeueReusableSupplementaryView(
                      ofKind: kind,
                      withReuseIdentifier: KeywordSectionHeaderView.identifier,
                      for: indexPath
                  ) as? KeywordSectionHeaderView
            else {
                return UICollectionReusableView()
            }
            header.configure(section: section)
            
            header.delegate = self
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == layoutView.socialFeedCollectionView {
            didTapPost(at: indexPath)
        } else if collectionView == layoutView.searchView.keywordCollectionView {
            didTapKeyword(at: indexPath)
        }
    }
    
    private func didTapKeyword(at indexPath: IndexPath) {
        guard let section = SocialSearchView.KeywordSection(rawValue: indexPath.section) else { return }
        switch section {
        case .recent:
            let keyword = viewModel.recentKeywords[indexPath.item].word
            input.send(.search(term: keyword))
            layoutView.searchView.searchBar.text = keyword
        case .popular:
            let keyword = viewModel.popularKeywords[indexPath.item].word
            input.send(.search(term: keyword))
            layoutView.searchView.searchBar.text = keyword
        }
        layoutView.hideSearchView()
    }
    
    private func didTapPost(at indexPath: IndexPath) {
        let postId = viewModel.posts[indexPath.item].id
        coordinator?.didTapPost(id: postId)
    }
}

// MARK: Input

extension SocialListViewController: SocialPostDelegate, TDDropDownDelegate, UIScrollViewDelegate {
    func didTapBlock(_ cell: UICollectionViewCell, _ userID: User.ID) {
        let controller = SocialBlockViewController()
        controller.onBlock = { [weak self] in
            self?.input.send(.blockUser(to: userID))
        }
        presentPopup(with: controller)
    }
    
    func didTapEditPost(_ cell: UICollectionViewCell, _ post: Post) {
        coordinator?.didTapEditPost(post: post)
    }
    
    func didTapDeletePost(_ cell: UICollectionViewCell, _ postID: Post.ID) {
        input.send(.deletePost(postID))
    }
    
    func didTapReport(_ cell: UICollectionViewCell, _ postID: Post.ID) {
        coordinator?.didTapReport(id: postID)
    }
    
    func didTapRoutineView(_ cell: UICollectionViewCell, _ routine: Routine) {
        coordinator?.didTapRoutine(routine: routine)
    }
    
    func didTapNicknameLabel(_ cell: UICollectionViewCell, _ userID: User.ID) {
        coordinator?.didTapUserProfile(id: userID)
    }
    
    func didTapLikeButton(_ cell: UICollectionViewCell, _ postID: Post.ID) {
        input.send(.likePost(postID))
    }
    
    @objc func didTapSegmentedControl(sender: TDSegmentedControl) {
        input.send(.segmentSelect(at: sender.selectedIndex))
        layoutView.updateLayoutForSegmentedControl(index: sender.selectedIndex)
    }
    
    @objc func didRefresh() {
        input.send(.refreshPosts)
    }
    
    @objc func didTapCreateButton() {
        coordinator?.didTapCreateButton()
    }
    
    func dropDown(_ dropDownView: TDDropdownHoverView, didSelectRowAt indexPath: IndexPath) {
        let option = SocialSortType.allCases[indexPath.row]
        layoutView.dropDownAnchorView.setTitle(option.rawValue)
        input.send(.sortPost(by: option))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.5 {
            input.send(.loadMorePosts)
        }
    }
}

// MARK: - 검색 및 삭제버튼 처리

extension SocialListViewController: UISearchBarDelegate, CancleTagCellDelegate, KeywordHeaderCellDelegate {
    func didTapAllDeleteButton(cell: KeywordSectionHeaderView) {
        input.send(.deleteRecentAllKeywords)
    }

    func didTapCancleButton(cell: CancleTagCell) {
        guard let indexPath = layoutView.searchView.keywordCollectionView.indexPath(for: cell),
              let section = SocialSearchView.KeywordSection(rawValue: indexPath.section)
        else { return }

        if section == .recent {
            input.send(.deleteRecentKeyword(index: indexPath.item))
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        layoutView.hideSearchView()
        input.send(.search(term: searchText))
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            input.send(.loadKeywords)
        }
    }
}

// MARK: Collection View Datasource Apply

extension SocialListViewController {
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts.map(\.id), toSection: 0)
        snapshot.reloadItems(posts.map(\.id))
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(_ post: Post) {
        var snapshot = datasource?.snapshot()
        snapshot?.reloadItems([post.id])
        datasource?.apply(snapshot!, animatingDifferences: false)
    }
    
    private func applyKeywordSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SocialSearchView.KeywordSection, Keyword>()
        snapshot.appendSections(SocialSearchView.KeywordSection.allCases)
        snapshot.appendItems(viewModel.recentKeywords, toSection: .recent)
        snapshot.appendItems(viewModel.popularKeywords, toSection: .popular)

        keywordDataSource.apply(snapshot, animatingDifferences: false)
    }
}
