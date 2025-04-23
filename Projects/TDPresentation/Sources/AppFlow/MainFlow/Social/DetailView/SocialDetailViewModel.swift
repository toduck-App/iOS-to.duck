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
        case createComment
        case registerImage(Data)
        case shareRoutine
        case reportPost
        case didTapComment(Comment)
        case reloadParentComment(Comment)
        case failure(String)
    }
    
    private let postID: Int
    private let fetchPostUsecase: FetchPostUseCase
    private let fetchCommentUsecase: FetchCommentUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let toggleCommentLikeUseCase: ToggleCommentLikeUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let reportPostUseCase: ReportPostUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var registerComment: Comment?
    private var registerImage: Data?
    private var currentComment: Comment? // 현재 댓글을 다려는 댓글?
    
    private(set) var post: Post?
    private(set) var comments: [Comment] = []
    
    init(
        fetchPostUsecase: FetchPostUseCase,
        fetchCommentUsecase: FetchCommentUseCase,
        togglePostLikeUseCase: TogglePostLikeUseCase,
        toggleCommentLikeUseCase: ToggleCommentLikeUseCase,
        createCommentUseCase: CreateCommentUseCase,
        reportPostUseCase: ReportPostUseCase,
        deleteCommentUseCase: DeleteCommentUseCase,
        blockUserUseCase: BlockUserUseCase,
        at postID: Post.ID
    ) {
        self.fetchPostUsecase = fetchPostUsecase
        self.fetchCommentUsecase = fetchCommentUsecase
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.toggleCommentLikeUseCase = toggleCommentLikeUseCase
        self.createCommentUseCase = createCommentUseCase
        self.reportPostUseCase = reportPostUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.blockUserUseCase = blockUserUseCase
        self.postID = postID
    }
    
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
                registerImage = data
                output.send(.registerImage(data))
            case .deleteRegisterImage:
                registerImage = nil
            case .shareRoutine:
                break
            case .reportPost:
                break
            case .blockPost:
                break
            case .blockUser(let userID):
                Task { await self.blockUser(to: userID) }
            case .likeComment(let commentID):
                Task { await self.likeComment(commentID: commentID) }
            case .didTapComment(let commentID):
                currentComment = comments.first(where: { $0.id == commentID })
                guard let comment = currentComment else { return }
                output.send(.didTapComment(comment))
            case .deleteComment(let commentID):
                Task { await self.deleteComment(commentID: commentID) }
            }
        
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

private extension SocialDetailViewModel {
    func fetchPost() async {
        do {
            let result = try await fetchPostUsecase.execute(postID: postID)
            post = result.post
            comments = result.comments
            output.send(.post(result.post))
            output.send(.comments(result.comments))
        } catch {
            post = nil
            comments = []
            output.send(.failure("글을 불러오는데 실패했습니다."))
        }
    }
    
    // MARK: - Like(Post에 대한 Like)
    
    private func likePost() async {
        do {
            guard var post else {
                output.send(.failure("게시글 정보가 없습니다."))
                return
            }
            try await togglePostLikeUseCase.execute(postID: postID, currentLike: post.isLike)
            post.toggleLike()
            self.post = post
            output.send(.likePost(post))
        } catch {
            output.send(.failure("게시글 좋아요에 실패했습니다."))
        }
    }
    
    // MARK: - Reply에 대한 Like 구현
    
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
    
    // MARK: 댓글 달기
    
    private func registerComment(content: String) async {
        do {
            let image: (fileName: String, imageData: Data)? = registerImage != nil ? (fileName: "\(UUID().uuidString).jpg", imageData: registerImage!) : nil
            try await createCommentUseCase.execute(postID: postID, parentId: currentComment?.id, content: content, image: image)
            
            output.send(.createComment)
            await fetchPost()
            if let currentComment {
                output.send(.reloadParentComment(currentComment))
            }
            currentComment = nil
        } catch {
            output.send(.failure("댓글 등록에 실패했습니다."))
        }
    }
    
    // MARK: 댓글 삭제
    private func deleteComment(commentID: Comment.ID) async {
        do {
            try await deleteCommentUseCase.execute(postID: postID, commentID: commentID)
            self.comments = comments.filter { $0.id != commentID }
            if let parentComment = removeComment(in: &comments, for: commentID) {
                output.send(.reloadParentComment(parentComment))
            } else {
                output.send(.comments(comments))
            }
        } catch {
            output.send(.failure("댓글 삭제에 실패했습니다."))
        }
    }
    
    // MARK: Block User: 블락한 후 해당 유저의 모든 댓글을 제거
    private func blockUser(to userID: User.ID) async {
        do {
            try await blockUserUseCase.execute(userID: userID)
            removeAllComments(by: userID, in: &comments)
            output.send(.comments(comments))
        } catch {
            output.send(.failure("사용자 차단에 실패했습니다."))
        }
    }
}

private extension SocialDetailViewModel {
    /// 전체 댓글(중첩 reply 포함) 에서 주어진 commentID에 해당하는 댓글을 검색
    private func getComment(by id: Comment.ID, from comments: [Comment]) -> Comment? {
        for comment in comments {
            if comment.id == id {
                return comment
            }
            if let found = getComment(by: id, from: comment.reply) {
                return found
            }
        }
        return nil
    }
    
    /// 댓글 배열(inout)을 순회하며 주어진 commentID를 가진 댓글을 업데이트하는 함수
    /// 만약 top-level 댓글이면 바로 업데이트한 후 반환하고,
    /// nested reply인 경우, 해당 reply를 포함하고 있는 상위(top-level) 댓글을 반환합니다.
    private func updateComment(in comments: inout [Comment], for commentID: Comment.ID) -> Comment? {
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
    
    /// 댓글 배열 내에서 주어진 commentID를 가진 댓글을 재귀적으로 검색하여 업데이트 (toggleLike)
    private func updateNestedComment(in replies: inout [Comment], for commentID: Comment.ID) -> Bool {
        if let index = replies.firstIndex(where: { $0.id == commentID }) {
            replies[index].toggleLike()
            return true
        }
        for i in 0..<replies.count {
            if updateNestedComment(in: &replies[i].reply, for: commentID) {
                return true
            }
        }
        return false
    }
    
    /// 댓글 배열(inout)에서 주어진 commentID에 해당하는 댓글을 제거합니다.
    /// - Top-level 댓글이면 배열에서 제거한 후 그 댓글을 반환합니다.
    /// - Nested reply인 경우 해당 reply를 포함하고 있는 상위(부모) 댓글을 반환합니다.
    private func removeComment(in comments: inout [Comment], for commentID: Comment.ID) -> Comment? {
        if let index = comments.firstIndex(where: { $0.id == commentID }) {
            let removedComment = comments.remove(at: index)
            return removedComment
        }
        for i in 0..<comments.count {
            if let _ = removeComment(in: &comments[i].reply, for: commentID) {
                return comments[i]
            }
        }
        return nil
    }
    
    /// 재귀적으로 전체 댓글(중첩 reply 포함)에서 지정한 userID를 가진 댓글들을 제거합니다.
    private func removeAllComments(by userID: User.ID, in comments: inout [Comment]) {
        // top-level에서 해당 유저의 댓글을 제거
        comments = comments.filter { $0.user.id != userID }
        // 각 댓글의 reply 배열에 대해 재귀적으로 처리
        for i in 0..<comments.count {
            removeAllComments(by: userID, in: &comments[i].reply)
        }
    }
}
