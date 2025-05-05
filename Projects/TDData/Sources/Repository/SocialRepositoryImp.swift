import Foundation
import TDCore
import TDDomain

public final class SocialRepositoryImp: SocialRepository {
    private let socialService: SocialService
    private let awsService: AwsService
    
    public init(socialService: SocialService, awsService: AwsService) {
        self.socialService = socialService
        self.awsService = awsService
    }
    
    public func fetchPostList(cursor: Int?, limit: Int = 20, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let postListDTO = try await socialService.requestPosts(cursor: cursor, limit: limit, categoryIDs: categoryIDs)
        let postList = postListDTO.results.compactMap { $0.convertToPost() }
        
        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
    }
    
    public func searchPost(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let categoryIDs: [Int]? = category?.map(\.rawValue)
        let postListDTO = try await socialService.requestSearchPosts(cursor: cursor, limit: limit, keyword: keyword, categoryIDs: categoryIDs)
        let postList = postListDTO.results.compactMap { $0.convertToPost() }
        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
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
    
    public func updatePost(prevPost: Post, updatePost: Post, image: [(fileName: String, imageData: Data)]?) async throws {
        let isChangeTitle = prevPost.titleText != updatePost.titleText
        let isChangeRoutine = prevPost.routine?.id != updatePost.routine?.id
        let isChangeContent = prevPost.contentText != updatePost.contentText
        let isChangeCategory = prevPost.category != updatePost.category
        let isChangeImage = image != nil
        var imageUrls: [String] = []
        if isChangeImage, let image {
            for (fileName, imageData) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: imageData)
                imageUrls.append(urls.fileUrl.absoluteString)
            }
        }
        
        let requestDTO = TDPostUpdateRequestDTO(
            id: prevPost.id,
            isChangeTitle: isChangeTitle,
            title: isChangeTitle ? updatePost.titleText : nil,
            isChangeRoutine: isChangeRoutine,
            routineId: isChangeRoutine ? updatePost.routine?.id : nil,
            content: isChangeContent ? updatePost.contentText : nil,
            isAnonymous: false,
            socialCategoryIds: isChangeCategory ? updatePost.category?.compactMap(\.rawValue) ?? [] : nil,
            socialImageUrls: isChangeImage ? imageUrls : nil
        )
        try await socialService.requestUpdatePost(requestDTO: requestDTO)
    }
    
    public func deletePost(postID: Post.ID) async throws {
        try await socialService.requestDeletePost(postID: postID)
    }
    
    public func fetchPost(postID: Post.ID) async throws -> (Post, [Comment]) {
        let postDTO = try await socialService.requestPost(postID: postID)
        let post = postDTO.convertToPost()
        let comments = postDTO.convertToComment()
        
        return (post, comments)
    }
    
    public func reportPost(postID: Post.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws {
        try await socialService.requestReportPost(postID: postID, reportType: reportType.rawValue, reason: reason, blockAuthor: blockAuthor)
    }
    
    public func toggleCommentLike(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws {
        if currentLike {
            try await socialService.requestUnlikeComment(postID: postID, commentID: commentID)
        } else {
            try await socialService.requestLikeComment(postID: postID, commentID: commentID)
        }
    }
    
    public func createComment(
        postID: Post.ID,
        parentId: Comment.ID?,
        content: String,
        image: (fileName: String, imageData: Data)?
    ) async throws {
        var imageUrls: String?
        if let image {
            let urls = try await awsService.requestPresignedUrl(fileName: image.fileName)
            try await awsService.requestUploadImage(url: urls.presignedUrl, data: image.imageData)
            imageUrls = urls.fileUrl.absoluteString
        }
        
        try await socialService.requestCreateComment(socialId: postID, content: content, parentId: parentId, imageUrl: imageUrls)
    }
    
    public func updateComment(comment: Comment) async throws -> Bool {
        false
    }
    
    public func deleteComment(postID: Post.ID, commentID: Comment.ID) async throws {
        try await socialService.requestRemoveComment(postID: postID, commentID: commentID)
    }
    
    public func reportComment(postID: Post.ID, commentID: Comment.ID, reportType: ReportType, reason: String?, blockAuthor: Bool) async throws
    {
        try await socialService.requestReportComment(postID: postID, commentID: commentID, reportType: reportType.rawValue, reason: reason, blockAuthor: blockAuthor)
    }
}
