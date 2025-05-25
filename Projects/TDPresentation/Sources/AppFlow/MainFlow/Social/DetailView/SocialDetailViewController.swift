import Combine
import TDCore
import TDDesign
import TDDomain
import UIKit

final class SocialDetailViewController: BaseViewController<SocialDetailView> {
    private enum Section: Hashable, CaseIterable {
        case post
        case comments
    }
    
    private enum Item: Hashable {
        case post(Post.ID)
        case comment(Comment.ID)
    }
    
    let input = PassthroughSubject<SocialDetailViewModel.Input, Never>()
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    private let viewModel: SocialDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var scrollToCommentId: Comment.ID?
    weak var coordinator: SocialDetailCoordinator?
    
    public init(viewModel: SocialDetailViewModel) {
        self.viewModel = viewModel
        super.init()
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.fetchPost)
    }
    
    override func configure() {
        layoutView.detailCollectionView.delegate = self
        
        layoutView.commentImageView.onRemove = { [weak self] in
            self?.layoutView.removeCommentInputImage()
            self?.didTapDeleteImage()
        }
        layoutView.commentReplyView.onRemove = { [weak self] in
            self?.layoutView.removeReplyInputForm()
        }
        
        layoutView.commentInputForm.setTapSendButton(
            UIAction { [weak self] _ in
                self?.layoutView.commentInputForm.sendButton.isEnabled = false
                self?.input.send(.registerComment(self?.layoutView.commentInputForm.getText() ?? ""))
            })
        layoutView.commentInputForm.setTapImageButton(
            UIAction { [weak self] _ in
                let picker = TDPhotoPickerController(maximumSelectablePhotos: 1)
                picker.pickerDelegate = self
                self?.navigationController?.pushTDViewController(picker, animated: true)
            })
        
        datasource = .init(collectionView: layoutView.detailCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .post:
                let cell: SocialDetailPostCell = collectionView.dequeueReusableCell(for: indexPath)
                if let post = self.viewModel.post {
                    cell.configure(with: post)
                    cell.socialDetailPostCellDelegate = self
                    return cell
                }
                return cell
            case .comment(let id):
                let cell: SocialDetailCommentCell = collectionView.dequeueReusableCell(for: indexPath)
                if let comment = self.viewModel.comments.first(where: { $0.id == id }) {
                    cell.configure(with: comment)
                    cell.commentDelegate = self
                    return cell
                }
            }
            return UICollectionViewCell()
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.post, .comments])
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .post(let post):
                    self?.applySnapshot(items: [.post(post.id)], to: .post)
                case .comments(let comments):
                    let items = comments.map { Item.comment($0.id) }
                    self?.applySnapshot(items: items, to: .comments)
                    if let scrollToId = self?.scrollToCommentId {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self?.scrollToComment(withId: scrollToId)
                            self?.scrollToCommentId = nil
                        }
                    }
                case .likePost(let post):
                    self?.updateSnapshot(items: [.post(post.id)], to: .post)
                case .likeComment(let comment):
                    self?.updateSnapshot(items: [.comment(comment.id)], to: .comments)
                case .registerImage(let data):
                    self?.layoutView.showCommentInputImage(with: data)
                case .didTapComment(let comment):
                    self?.layoutView.showReplyInputForm(name: comment.user.name)
                case .createComment:
                    self?.layoutView.commentInputForm.sendButton.isEnabled = true
                    self?.layoutView.removeReplyInputForm()
                    self?.layoutView.clearText()
                    self?.layoutView.removeCommentInputImage()
                case .reloadParentComment(let comment):
                    self?.reloadParentComment(parentID: comment.id)
                case .failure(let message):
                    self?.layoutView.commentInputForm.sendButton.isEnabled = true
                    self?.showErrorAlert(errorMessage: message)
                default:
                    break
                }
            }.store(in: &cancellables)
    }
    
    func updateScrollToCommentId(_ id: Comment.ID) {
        scrollToCommentId = id
    }
    
    private func scrollToComment(withId id: Comment.ID) {
        let targetItem = Item.comment(id)
        
        guard let indexPath = datasource.indexPath(for: targetItem) else {
            return
        }

        layoutView.detailCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredVertically,
            animated: true
        )
    }
}

// MARK: User Action

extension SocialDetailViewController: SocialPostDelegate, TDPhotoPickerDelegate, UICollectionViewDelegate {
    func didTapProfileImage(_ cell: UICollectionViewCell, _ userID: TDDomain.User.ID) {
        coordinator?.didTapUserProfile(id: userID)
    }
    
    func didTapRoutineView(_ cell: UICollectionViewCell, _ routine: Routine) {
        coordinator?.didTapRoutine(routine: routine)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = datasource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .post:
            break
        case .comment(let commentID):
            input.send(.didTapComment(commentID))
        }
    }
    
    func didTapLikeButton(_ cell: UICollectionViewCell, _ postID: Post.ID) {
        guard let indexPath = layoutView.detailCollectionView.indexPath(for: cell) else { return }
        switch datasource.itemIdentifier(for: indexPath) {
        case .post:
            input.send(.likePost)
        case .comment(let commentID):
            input.send(.likeComment(commentID))
        default:
            break
        }
    }
    
    func didTapReplyLikeButton(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {
        input.send(.likeComment(commentID))
    }
    
    func didTapDeleteImage() {
        input.send(.deleteRegisterImage)
    }
    
    func didSelectPhotos(_ picker: TDDesign.TDPhotoPickerController, photos: [Data]) {
        guard let photo = photos.first else { return }
        input.send(.registerImage(photo))
    }
    
    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        showErrorAlert(errorMessage: "사진 접근 권한이 없습니다.")
    }
    
    func didTapBlock(_ cell: UICollectionViewCell, _ userID: User.ID) {
        let controller = SocialBlockViewController()
        controller.onBlock = { [weak self] in
            self?.input.send(.blockUser(userID))
        }
        presentPopup(with: controller)
    }
    
    func didTapReportComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {
        coordinator?.didTapReportComment(id: commentID)
    }
    
    func didTapEditComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {
        TDLogger.debug("EDIT COMMENT")
    }
    
    func didTapDeleteComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {
        input.send(.deleteComment(commentID))
    }
    
    func didTapNicknameLabel(_ cell: UICollectionViewCell, _ userID: User.ID) {
        coordinator?.didTapUserProfile(id: userID)
    }
}

// MARK: Iternal Method

extension SocialDetailViewController {
    private func applySnapshot(items: [Item], to section: Section) {
        var snapshot = datasource.snapshot()
        let existingItems = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems(existingItems)
        snapshot.appendItems(items, toSection: section)
        datasource.apply(snapshot, animatingDifferences: true)
    }

    private func updateSnapshot(items: [Item], to section: Section) {
        var snapshot = datasource.snapshot()
        snapshot.reloadItems(items)
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func reloadParentComment(parentID: Comment.ID) {
        var snapshot = datasource.snapshot()
        let items = snapshot.itemIdentifiers(inSection: .comments)
        let newItems = items.filter { item in
            if case .comment(let id) = item {
                return id == parentID
            }
            return false
        }
        snapshot.reloadItems(newItems)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
