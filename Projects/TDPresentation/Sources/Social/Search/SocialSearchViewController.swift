import Combine
import TDDesign
import TDDomain
import UIKit

enum KeywordSection: Int, CaseIterable {
    case recent
    case popular

    var title: String {
        switch self {
        case .recent:
            "최근 검색어"
        case .popular:
            "인기 검색어"
        }
    }

    var showRemoveButton: Bool {
        self == .recent
    }
}

final class SocialSearchViewController: BaseViewController<SocialSearchView> {
    
    weak var coordinator: SocialSearchCoordinator?
    private let input = PassthroughSubject<SocialSearchViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SocialSearchViewModel!
    private var keywordDataSource: UICollectionViewDiffableDataSource<KeywordSection, SocialSearchViewModel.Keyword>!
    private var resultDataSource: UICollectionViewDiffableDataSource<Int, Post.ID>?

    init(viewModel: SocialSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.loadKeywords)
    }

    override func configure() {
        setupNavigationBar()
        configureDataSource()
        layoutView.keywordCollectionView.delegate = self
        layoutView.keywordCollectionView.dataSource = keywordDataSource
        layoutView.postCollectionView.delegate = self
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .searchResult:
                    layoutView.showResultView()
                    applyResultSnapshot()
                case .updateKeywords:
                    layoutView.showRecommendView()
                    applyKeywordSnapshot()
                case .selectPost:
                    guard let postID = self.viewModel.selectedPostID else { return }
                    coordinator?.didTapPost(id: postID)
                case .likePost(let post):
                    updateResultSnapshot(post)
                case .failure(let message):
                    break
                }
            }.store(in: &cancellables)
    }

    private func setupNavigationBar() {
        layoutView.cancleButton.addAction(UIAction { [weak self] _ in
            self?.layoutView.searchBar.text = ""
            self?.layoutView.showKeyboard()
            self?.input.send(.loadKeywords)
//            self?.coordinator?.finish()
        }, for: .touchUpInside)

        navigationItem.titleView = layoutView.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutView.cancleButton)

        layoutView.searchBar.delegate = self
    }

    private func configureDataSource() {
        keywordDataSource = UICollectionViewDiffableDataSource<KeywordSection, SocialSearchViewModel.Keyword>(
            collectionView: layoutView.keywordCollectionView
        ) { [weak self] collectionView, indexPath, keyword in
            guard let section = KeywordSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
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
                  let section = KeywordSection(rawValue: indexPath.section),
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
        
        resultDataSource = .init(collectionView: layoutView.postCollectionView, cellProvider: { collectionView, indexPath, postID in
            guard let post = self.viewModel.searchResult.first(where: { $0.id == postID }) else { return UICollectionViewCell() }
            let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.socialFeedCellDelegate = self
            cell.configure(with: post)
            
            return cell
        })
    }

    private func applyKeywordSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<KeywordSection, SocialSearchViewModel.Keyword>()
        snapshot.appendSections(KeywordSection.allCases)
        snapshot.appendItems(viewModel.recentKeywords, toSection: .recent)
        snapshot.appendItems(viewModel.popularKeywords, toSection: .popular)

        keywordDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyResultSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.searchResult.map { $0.id })

        resultDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateResultSnapshot(_ post: Post) {
        var snapshot = resultDataSource?.snapshot()
        snapshot?.reloadItems([post.id])
        resultDataSource?.apply(snapshot!, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension SocialSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == layoutView.keywordCollectionView {
            didSelectKeyword(at: indexPath)
        } else if collectionView == layoutView.postCollectionView {
            didSelectPost(at: indexPath)
        }
    }
    
    private func didSelectKeyword(at indexPath: IndexPath) {
        guard let section = KeywordSection(rawValue: indexPath.section) else { return }
        switch section {
        case .recent:
            let keyword = viewModel.recentKeywords[indexPath.item].word
            input.send(.search(query: keyword))
            layoutView.searchBar.text = keyword
        case .popular:
            let keyword = viewModel.popularKeywords[indexPath.item].word
            input.send(.search(query: keyword))
            layoutView.searchBar.text = keyword
        }
        layoutView.hideKeyboard()
    }
    
    private func didSelectPost(at indexPath: IndexPath) {
        let postID = viewModel.searchResult[indexPath.item].id
        input.send(.selectPost(post: postID))
    }
}

// MARK: - 삭제버튼 처리

extension SocialSearchViewController: CancleTagCellDelegate, KeywordHeaderCellDelegate {
    func didTapAllDeleteButton(cell: KeywordSectionHeaderView) {
        input.send(.deleteRecentAllKeywords)
    }

    func didTapCancleButton(cell: CancleTagCell) {
        guard let indexPath = layoutView.keywordCollectionView.indexPath(for: cell),
              let section = KeywordSection(rawValue: indexPath.section)
        else { return }

        if section == .recent {
            input.send(.deleteRecentKeyword(index: indexPath.item))
        }
    }
}

// MARK: - UISearchBarDelegate

extension SocialSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        input.send(.search(query: searchText))
        layoutView.hideKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            input.send(.loadKeywords)
        }
    }
}

extension SocialSearchViewController: SocialFeedCollectionViewCellDelegate, TDPopupPresentable {
    func didTapBlock(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.postCollectionView.indexPath(for: cell) else {
            return
        }
        let controller = SocialBlockViewController()
        controller.onBlock = { [weak self] in
            guard let user = self?.viewModel.searchResult[indexPath.item].user else { return }
            self?.input.send(.blockUser(to: user))
        }
        presentPopup(with: controller)
    }
    
    func didTapReport(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.postCollectionView.indexPath(for: cell) else {
            return
        }
        coordinator?.didTapReport(id: viewModel.searchResult[indexPath.item].id)
    }
    
    func didTapRoutineView(_ cell: SocialFeedCollectionViewCell) {
        // TODO: Routine 공유 View
    }
    
    func didTapNicknameLabel(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.postCollectionView.indexPath(for: cell) else {
            return
        }
        let user = viewModel.searchResult[indexPath.item].user
        coordinator?.didTapUserProfile(id: user.id)
    }
    
    func didTapLikeButton(_ cell: SocialFeedCollectionViewCell) {
        guard let indexPath = layoutView.postCollectionView.indexPath(for: cell) else {
            return
        }
        input.send(.likePost(at: indexPath.item))
    }
}
