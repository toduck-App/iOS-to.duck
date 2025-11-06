import Combine
import TDCore
import TDDesign
import TDDomain
import UIKit

final class SocialListViewController: BaseViewController<SocialListView> {
    // MARK: - Dependencies
    weak var coordinator: SocialListCoordinator?
    private let viewModel: SocialListViewModel!
    
    // MARK: - Combine
    private let input = PassthroughSubject<SocialListViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Data
    private var datasource: UICollectionViewDiffableDataSource<Int, Post.ID>?
    private var keywordDataSource: UICollectionViewDiffableDataSource<SocialSearchView.KeywordSection, Keyword>!
    
    // ✅ 변경: VM 내부 컬렉션에 의존하지 않고 VC가 현재 스냅샷을 캐시
    private var latestPosts: [Post] = []
    // ✅ 변경: 셀 하이라이트를 위해 마지막 검색어를 VC가 보관
    private var lastSearchTerm: String = ""
    
    // MARK: - Init
    init(viewModel: SocialListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultNavigationBar()
        input.send(.appear)
    }
    
    // MARK: - NavigationBar
    private func setupDefaultNavigationBar() {
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
        
        // 우측 버튼 설정 (검색 버튼 + 알람 버튼)
        navigationItem.titleView = nil
        let alarmButton = UIButton(type: .custom)
        alarmButton.setImage(TDImage.Bell.topOffMedium, for: .normal)
        alarmButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.didTapAlarmButton()
        }, for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: alarmButton),
            UIBarButtonItem(customView: layoutView.searchButton)
        ]
    }
    
    private func setupNavigationSearchBar() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: layoutView.searchView.backButton)]
        navigationItem.titleView = layoutView.searchView.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutView.searchView.cancleButton)
    }
    
    // MARK: - Configure
    override func configure() {
        layoutView.searchButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.showSearchView()
            self?.setupNavigationSearchBar()
            self?.input.send(.loadKeywords)
        }, for: .touchUpInside)
        
        let hideSearch: UIActionHandler = { [weak self] _ in
            guard let self else { return }
            self.layoutView.hideSearchView()
            self.layoutView.clearSearchText()
            self.setupDefaultNavigationBar()
            self.lastSearchTerm = ""
            self.input.send(.clearSearch)
        }
        layoutView.searchView.backButton.addAction(UIAction(handler: hideSearch), for: .touchUpInside)
        layoutView.searchView.cancleButton.addAction(UIAction(handler: hideSearch), for: .touchUpInside)
        
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
    
    // MARK: - Binding
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                    
                // ✅ 변경: 단일 posts 스트림으로 통일
                case .posts(let posts):
                    self.layoutView.showFinishView()
                    self.latestPosts = posts
                    self.applySnapshot(posts)
                    
                case .updateKeywords:
                    self.applyKeywordSnapshot()
                    
                case .failure(let message):
                    self.showErrorAlert(errorMessage: message)
                }
            }
            .store(in: &cancellables)
    }
}

extension SocialListViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        input.send(.chipSelect(at: index))
    }
}

// MARK: - CollectionView Delegate & DataSources
extension SocialListViewController: UICollectionViewDelegate {
    private func setupDataSource() {
        // ✅ 변경: cellProvider에서 viewModel.posts 대신 VC의 latestPosts 사용
        datasource = .init(collectionView: layoutView.socialFeedCollectionView, cellProvider: { [weak self] collectionView, indexPath, postID in
            guard
                let self,
                let post = self.latestPosts.first(where: { $0.id == postID })
            else { return UICollectionViewCell() }
            
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.socialFeedCellDelegate = self
            
            let highlight: String? = self.lastSearchTerm.isEmpty ? nil : self.lastSearchTerm
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
                ) as? CancleTagCell else { return UICollectionViewCell() }
                cell.configure(tag: keyword.word)
                cell.delegate = self
                return cell
            case .popular:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TagCell.identifier,
                    for: indexPath
                ) as? TagCell else { return UICollectionViewCell() }
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
    
    // ✅ 변경: 개수도 latestPosts 기준
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        latestPosts.count
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
            lastSearchTerm = keyword                // ✅ VC에서 보관
            input.send(.search(term: keyword))
            layoutView.searchView.searchBar.text = keyword
        case .popular:
            let keyword = viewModel.popularKeywords[indexPath.item].word
            lastSearchTerm = keyword                // ✅ VC에서 보관
            input.send(.search(term: keyword))
            layoutView.searchView.searchBar.text = keyword
        }
        layoutView.hideSearchView()
    }
    
    private func didTapPost(at indexPath: IndexPath) {
        let postId = latestPosts[indexPath.item].id
        coordinator?.didTapPost(postId: postId, commentId: nil)
    }
}

// MARK: - Inputs from Cells / UI
extension SocialListViewController: SocialPostDelegate, TDDropDownDelegate, UIScrollViewDelegate {
    func didTapProfileImage(_ cell: UICollectionViewCell, _ userID: TDDomain.User.ID) {
        coordinator?.didTapUserProfile(id: userID)
    }
    
    func didTapBlock(_ cell: UICollectionViewCell, _ userID: User.ID) {
        let controller = SocialBlockViewController()
        controller.onBlock = { [weak self] in
            self?.input.send(.blockUser(userID))
        }
        presentPopup(with: controller)
    }
    
    func didTapEditPost(_ cell: UICollectionViewCell, _ post: Post) {
        coordinator?.didTapEditPost(post: post)
    }
    
    func didTapDeletePost(_ cell: UICollectionViewCell, _ postID: Post.ID) {
        let deleteDiaryViewController = DeleteEventViewController(
            eventId: postID,
            isRepeating: false,
            eventMode: .socialPost
        )
        deleteDiaryViewController.delegate = self
        presentPopup(with: deleteDiaryViewController)
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
        // ✅ 변경: currentLike는 VC 캐시에서 조회
        guard let current = latestPosts.first(where: { $0.id == postID }) else { return }
        // 프로젝트에 따라 isLike / isLiked 네이밍 다를 수 있음
        let currentLike = current.isLike   // or current.isLiked
        input.send(.likePost(postID, currentLike: currentLike))
    }
    
    @objc func didTapSegmentedControl(sender: TDSegmentedControl) {
        input.send(.segmentSelect(at: sender.selectedIndex))
        layoutView.updateLayoutForSegmentedControl(index: sender.selectedIndex)
    }
    
    @objc func didRefresh() {
        input.send(.refresh)
    }
    
    @objc func didTapCreateButton() {
        HapticManager.impact(.soft)
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
            // ✅ 변경: .loadMorePosts → .loadMore
            input.send(.loadMore)
        }
    }
    
    func showEventJoinAlert() {
        presentPopup(with: SocialEventJoinSuccessViewController())
    }
}

// MARK: - DeleteEventViewControllerDelegate
extension SocialListViewController: DeleteEventViewControllerDelegate {
    func didTapTodayDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode) {
        guard let id = eventId else { return }
        input.send(.deletePost(id))
        dismiss(animated: true)
    }
    func didTapAllDeleteButton(eventId: Int?, eventMode: DeleteEventViewController.EventMode) { }
}

// MARK: - Search & Keyword
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
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchText.isEmpty else { return }
        layoutView.hideSearchView()
        // ✅ VC에서 검색어 보관 → 셀 하이라이트에 사용
        lastSearchTerm = searchText
        input.send(.search(term: searchText))
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            input.send(.loadKeywords)
        }
    }
}

// MARK: - Diffable Snapshot
extension SocialListViewController {
    private func applySnapshot(_ posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(posts.map(\.id), toSection: 0)
        snapshot.reloadItems(posts.map(\.id))
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyKeywordSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SocialSearchView.KeywordSection, Keyword>()
        snapshot.appendSections(SocialSearchView.KeywordSection.allCases)
        snapshot.appendItems(viewModel.recentKeywords, toSection: .recent)
        snapshot.appendItems(viewModel.popularKeywords, toSection: .popular)
        keywordDataSource.apply(snapshot, animatingDifferences: false)
    }
}
