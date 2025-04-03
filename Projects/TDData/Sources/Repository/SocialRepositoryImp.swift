import Foundation
import TDCore
import TDDomain

public final class SocialRepositoryImp: SocialRepository {
    private var comments: [Comment] = Comment.dummy
    private var dummyPost = Post.dummy

    private let socialService: SocialService
    private let awsService: AwsService
    private let cachePost: [Post] = []

    public init(socialService: SocialService, awsService: AwsService) {
        self.socialService = socialService
        self.awsService = awsService
    }

    public func fetchPostList(cursor: Int?, limit: Int = 20, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let postListDTO = try await socialService.requestPosts(cursor: cursor, limit: limit, categoryIDs: categoryIDs)
        let postList = postListDTO.results.compactMap { $0.convertToEntity(category: category) }

        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
    }

    public func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let postListDTO = try await socialService.requestSearchPosts(cursor: cursor, limit: limit, keyword: keyword)
        let postList = postListDTO.results.compactMap { $0.convertToEntity(category: category) }
        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
        // TODO: 카테고리 필터 필요
    }

    public func togglePostLike(postID: Post.ID, currentLike: Bool) async throws {
        if currentLike {
            try await socialService.requestUnlikePost(postID: postID)
        } else {
            try await socialService.requestLikePost(postID: postID)
        }
    }

    public func createPost(post: Post, image: [(fileName: String, imageData: Data)]?) async throws {
        var imageUrls: [String] = []
        if let image {
            for (fileName, imageData) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: imageData)
                imageUrls.append(urls.fileUrl.absoluteString)
            }
        }

        let requestDTO = TDPostCreateRequestDTO(
            title: post.titleText,
            content: post.contentText,
            routineId: post.routine?.id,
            isAnonymous: false,
            socialCategoryIds: post.category?.compactMap(\.rawValue) ?? [],
            socialImageUrls: imageUrls
        )
        try await socialService.requestCreatePost(requestDTO: requestDTO)
    }

    public func updatePost(post: Post) async throws {}

    public func deletePost(postID: Post.ID) async throws {
        try await socialService.requestDeletePost(postID: postID)
    }

    public func fetchPost(postID: Post.ID) async throws -> Post {
        let postDTO = try await socialService.requestPost(postID: postID)
        let post = postDTO.convertToEntity()

        return post
    }

    public func reportPost(postID: Post.ID) async throws {}

    public func blockPost(postID: Post.ID) async throws {}
    
    public func toggleCommentLike(commentID: Comment.ID) async throws -> Result<Comment, Error> {
        for index in comments.indices {
            // 댓글인 경우
            if comments[index].id == commentID {
                comments[index].toggleLike()
                return .success(comments[index])
            }
            // 대댓글인 경우
            if let replyIndex = comments[index].reply.firstIndex(where: { $0.id == commentID }) {
                comments[index].reply[replyIndex].toggleLike()
                return .success(comments[index])
            }
        }
        // TODO: 해당 ID를 가진 댓글이나 대댓글이 없는 경우
        return .failure(NSError(domain: "CommentRepositoryImpl", code: 0, userInfo: nil))
    }
    
    public func fetchCommentList(postID: Post.ID) async throws -> [Comment]? {
        comments
    }
    
    public func fetchCommentList(commentID: Comment.ID) async throws -> [Comment]? {
        []
    }
    
    public func fetchUserCommentList(userID: User.ID) async throws -> [Comment]? {
        []
    }
    
    public func createComment(comment newComment: NewComment) async throws -> Bool {
        let createdComment = Comment(
            id: 4,
            user: User.dummy[0],
            content: newComment.content,
            imageURL: URL(string: "https://picsum.photos/250/250"),
            timestamp: Date(),
            isLike: false,
            likeCount: 0,
            comment: []
        )
        
        switch newComment.target {
        case .post(let postID):
            // TODO: Network 작업을 통해 서버에 댓글을 등록하고, 성공 시 comments에 추가
            comments.append(createdComment)
            return true
            
        case .comment(let parentCommentID):
            // TODO: Network 작업을 통해 서버에 대댓글을 등록하고, 성공 시 comments에 추가
            // 현재는 부모 댓글을 찾아 대댓글을 추가
            var added = addReply(newComment: createdComment, toCommentID: parentCommentID, in: &comments)
            if added {
                return true
            } else {
                throw NSError(domain: "CommentRepositoryImpl", code: 404, userInfo: [NSLocalizedDescriptionKey: "부모 댓글을 찾을 수 없습니다."])
            }
        }
    }
    
    public func updateComment(comment: Comment) async throws -> Bool {
        false
    }
    
    public func deleteComment(commentID: Comment.ID) async throws -> Bool {
        false
    }
    
    public func reportComment(commentID: Comment.ID) async throws -> Bool {
        false
    }
    
    public func blockComment(commentID: Comment.ID) async throws -> Bool {
        false
    }
    
    // MARK: - Private Helper
    
    @discardableResult
    private func addReply(newComment: Comment, toCommentID parentCommentID: Int, in commentsArray: inout [Comment]) -> Bool {
        for index in commentsArray.indices {
            if commentsArray[index].id == parentCommentID {
                commentsArray[index].reply.append(newComment)
                return true
            } else {
                if addReply(newComment: newComment, toCommentID: parentCommentID, in: &commentsArray[index].reply) {
                    return true
                }
            }
        }
        return false
    }
}
