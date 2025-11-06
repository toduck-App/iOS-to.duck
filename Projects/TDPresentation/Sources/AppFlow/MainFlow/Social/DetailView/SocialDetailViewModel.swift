import Combine
import Foundation
import TDDomain

public final class SocialDetailViewModel: BaseViewModel {
    enum Input {
        case fetchPost
        case likePost
        case likeComment(Comment.ID)
        case registerComment(String)
        case registerImage(Data)
        case deleteRegisterImage
        case shareRoutine
        case reportPost
        case blockPost
        case blockUser(User.ID)
        case didTapComment(Comment.ID)
        case deleteComment(Comment.ID)
    }
    
    enum Output {
        case post(Post)
        case comments([Comment])
        case likePost(Post)
        case likeComment(Comment)
        case createComment(Comment.ID)
        case registerImage(Data)
        case shareRoutine
        case reportPost
        case didTapComment(Comment)
        case reloadParentComment(Comment)
        case failure(String)
    }
    
    // MARK: - Dependencies
    private let repo: SocialRepository
    private let fetchPostUsecase: FetchPostUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let toggleCommentLikeUseCase: ToggleCommentLikeUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let reportPostUseCase: ReportPostUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase
    private let blockUserUseCase: BlockUserUseCase
    
    // MARK: - State
    private(set) var postID: Int
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var registerImage: Data?
    private var currentComment: Comment? // 현재 댓글(답글 타겟)
    
    private(set) var post: Post?
    private(set) var comments: [Comment] = []
    
    // MARK: - Init
    public init(
        repo: SocialRepository,
        fetchPostUsecase: FetchPostUseCase,
        togglePostLikeUseCase: TogglePostLikeUseCase,
        toggleCommentLikeUseCase: ToggleCommentLikeUseCase,
        createCommentUseCase: CreateCommentUseCase,
        reportPostUseCase: ReportPostUseCase,
        deleteCommentUseCase: DeleteCommentUseCase,
        blockUserUseCase: BlockUserUseCase,
        at postID: Post.ID
    ) {
        self.repo = repo
        self.fetchPostUsecase = fetchPostUsecase
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.toggleCommentLikeUseCase = toggleCommentLikeUseCase
        self.createCommentUseCase = createCommentUseCase
        self.reportPostUseCase = reportPostUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.blockUserUseCase = blockUserUseCase
        self.postID = postID
        
        bindRepository()
    }
    
    // MARK: - Bind SSOT
    private func bindRepository() {
        repo.postPublisher
            .compactMap { [weak self] posts -> Post? in
                guard let self else { return nil }
                return posts.first(where: { $0.id == self.postID })
            }
            .sink { [weak self] latest in
                guard let self else { return }
                self.post = latest
                self.output.send(.post(latest))
                self.output.send(.likePost(latest))
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Transform
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .fetchPost:
                Task { await self.fetchPost() }
                
            case .likePost:
                Task { await self.likePost() }
                
            case .registerComment(let content):
                Task { await self.registerComment(content: content) }
                
            case .registerImage(let data):
                self.registerImage = data
                self.output.send(.registerImage(data))
                
            case .deleteRegisterImage:
                self.registerImage = nil
                
            case .shareRoutine:
                self.output.send(.shareRoutine)
                
            case .reportPost:
                self.output.send(.reportPost)
                
            case .blockPost:
                break
                
            case .blockUser(let userID):
                Task { await self.blockUser(to: userID) }
                
            case .likeComment(let commentID):
                Task { await self.likeComment(commentID: commentID) }
                
            case .didTapComment(let commentID):
                self.currentComment = self.comments.first(where: { $0.id == commentID })
                if let comment = self.currentComment {
                    self.output.send(.didTapComment(comment))
                }
                
            case .deleteComment(let commentID):
                Task { await self.deleteComment(commentID: commentID) }
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

// MARK: - Private
private extension SocialDetailViewModel {
    func fetchPost() async {
        do {
            let result = try await repo.fetchPost(postID: postID)
            self.post = result.0
            self.comments = result.1
            output.send(.post(result.0))
            output.send(.comments(result.1))
        } catch {
            post = nil
            comments = []
            output.send(.failure("글을 불러오는데 실패했습니다."))
        }
    }
    
    // MARK: - Like(Post)
    private func likePost() async {
        do {
            guard let post else {
                output.send(.failure("게시글 정보가 없습니다."))
                return
            }
            try await togglePostLikeUseCase.execute(postID: postID, currentLike: post.isLike)
        } catch {
            output.send(.failure("게시글 좋아요에 실패했습니다."))
        }
    }
    
    // MARK: - Like(Comment)
    private func likeComment(commentID: Comment.ID) async {
        do {
            guard let post else {
                output.send(.failure("게시글 정보가 없습니다."))
                return
            }
            guard let currentComment = getComment(by: commentID, from: comments) else {
                output.send(.failure("해당 댓글을 찾을 수 없습니다."))
                return
            }
            
            try await toggleCommentLikeUseCase.execute(
                postID: post.id,
                commentID: commentID,
                currentLike: currentComment.isLike
            )
            
            if let parentComment = updateComment(in: &comments, for: commentID) {
                output.send(.likeComment(parentComment))
            } else {
                output.send(.failure("댓글 상태 업데이트에 실패했습니다."))
            }
        } catch {
            output.send(.failure("댓글 좋아요에 실패했습니다."))
        }
    }
    
    // MARK: - Create Comment
    private func registerComment(content: String) async {
        do {
            let image: (fileName: String, imageData: Data)? =
                registerImage.map { (fileName: "\(UUID().uuidString).jpg", imageData: $0) }

            let newID = try await createCommentUseCase.execute(
                postID: postID,
                parentId: currentComment?.id,
                content: content,
                image: image
            )
            await fetchPost()
            if let parent = currentComment {
                output.send(.reloadParentComment(parent))
            }
            currentComment = nil
            registerImage = nil
            output.send(.createComment(newID))
        } catch {
            output.send(.failure("댓글 등록에 실패했습니다."))
        }
    }

    
    // MARK: - Delete Comment
    private func deleteComment(commentID: Comment.ID) async {
        do {
            try await deleteCommentUseCase.execute(postID: postID, commentID: commentID)
            self.comments = comments.filter { $0.id != commentID }
            if let parentComment = removeComment(in: &comments, for: commentID) {
                output.send(.reloadParentComment(parentComment))
            } else {
                output.send(.comments(comments))
            }
            await fetchPost()
        } catch {
            output.send(.failure("댓글 삭제에 실패했습니다."))
        }
    }

    
    // MARK: - Block User: 블락 후 해당 유저 댓글 제거
    private func blockUser(to userID: User.ID) async {
        do {
            try await blockUserUseCase.execute(userID: userID)
            removeAllComments(by: userID, in: &comments)
            output.send(.comments(comments))
            await fetchPost()
        } catch {
            output.send(.failure("사용자 차단에 실패했습니다."))
        }
    }

}

// MARK: - Comment Utilities
private extension SocialDetailViewModel {
    func getComment(by id: Comment.ID, from comments: [Comment]) -> Comment? {
        for comment in comments {
            if comment.id == id { return comment }
            if let found = getComment(by: id, from: comment.reply) { return found }
        }
        return nil
    }
    
    @discardableResult
    func updateComment(in comments: inout [Comment], for commentID: Comment.ID) -> Comment? {
        if let index = comments.firstIndex(where: { $0.id == commentID }) {
            comments[index].toggleLike()
            return comments[index]
        }
        for i in 0..<comments.count {
            if updateNestedComment(in: &comments[i].reply, for: commentID) {
                return comments[i]
            }
        }
        return nil
    }
    
    func updateNestedComment(in replies: inout [Comment], for commentID: Comment.ID) -> Bool {
        if let index = replies.firstIndex(where: { $0.id == commentID }) {
            replies[index].toggleLike()
            return true
        }
        for i in 0..<replies.count {
            if updateNestedComment(in: &replies[i].reply, for: commentID) { return true }
        }
        return false
    }
    
    @discardableResult
    func removeComment(in comments: inout [Comment], for commentID: Comment.ID) -> Comment? {
        if let index = comments.firstIndex(where: { $0.id == commentID }) {
            let removed = comments.remove(at: index)
            return removed
        }
        for i in 0..<comments.count {
            if let _ = removeComment(in: &comments[i].reply, for: commentID) {
                return comments[i]
            }
        }
        return nil
    }
    
    func removeAllComments(by userID: User.ID, in comments: inout [Comment]) {
        comments = comments.filter { $0.user.id != userID }
        for i in 0..<comments.count {
            removeAllComments(by: userID, in: &comments[i].reply)
        }
    }
}
