import Combine
import TDCore
import TDDomain
import TDDesign
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
    
    weak var coordinator: SocialDetailCoordinator?
    
    let input = PassthroughSubject<SocialDetailViewModel.Input, Never>()
    private var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    private let viewModel: SocialDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
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
                    TDLogger.debug("Comment: \(comment.reply)")
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
                case .likePost(let post):
                    self?.updateSnapshot(items: [.post(post.id)], to: .post)
                case .likeComment(let comment):
                    self?.updateSnapshot(items: [.comment(comment.id)], to: .comments)
                case .registerImage(let data):
                    self?.layoutView.showCommentInputImage(with: data)
                case .didTapComment(let comment):
                    self?.layoutView.showReplyInputForm(name: comment.user.name)
                case .createComment:
                    self?.layoutView.removeReplyInputForm()
                    self?.layoutView.clearText()
                    self?.layoutView.removeCommentInputImage()
                case .deleteComment(let comment):
                    let newItems = self?.viewModel.comments.map { Item.comment($0.id) } ?? []
                    self?.applySnapshot(items: newItems, to: .comments)
                case .failure(let message):
                    self?.showErrorAlert(errorMessage: message)
                default:
                    break
                }
            }.store(in: &cancellables)
    }
}

// MARK: User Action

extension SocialDetailViewController: SocialPostDelegate, TDPhotoPickerDelegate, UICollectionViewDelegate {
    
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
        self.input.send(.deleteRegisterImage)
    }
    
    func didSelectPhotos(_ picker: TDDesign.TDPhotoPickerController, photos: [Data]) {
        guard let photo = photos.first else { return }
        self.input.send(.registerImage(photo))
    }
    
    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        // TODO: - Denied Photo Access
        let alert = UIAlertController(title: "알림", message: "사진 접근 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapBlock(_ cell: UICollectionViewCell, _ userID: User.ID) {
        let controller = SocialBlockViewController()
        controller.onBlock = { [weak self] in
            self?.input.send(.blockUser(userID))
        }
        presentPopup(with: controller)
    }
    
    func didTapReport(_ cell: UICollectionViewCell, _ postID: Post.ID) {
        TDLogger.debug("REPORT POST")
    }
    
    func didTapEditComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {
        TDLogger.debug("EDIT COMMENT")
    }
    
    func didTapDeleteComment(_ cell: UICollectionViewCell, _ commentID: Comment.ID) {
        self.input.send(.deleteComment(commentID))
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
}
