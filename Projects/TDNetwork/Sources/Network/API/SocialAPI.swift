import Foundation
import TDCore
import TDData
import TDDomain

public enum SocialAPI {
    case fetchPostList(curser: Int?, limit: Int, categoryIds: [Int]?)
    case searchPost(keyword: String, curser: Int?, limit: Int) // TODO: Search 쪽 PageNation 구현 필요
    case likePost(postId: Int)
    case unlikePost(postId: Int)
    case createPost(post: TDPostCreateRequestDTO)
    case updatePost(post: Post) // TODO: Post 수정기능 필요
    case deletePost(postId: Int)
    case fetchPost(postId: String)
    case reportPost(postId: Int, reportType: String, reason: String?, blockAuthor: Bool) // MARK: RequestBody가 이상하여 잠시 보류
    case blockUser(userId: Int) // TODO: 유저 차단
    
    case toggleCommentLike(commentId: String) // TODO: Comment 구현 기능 필요
    case fetchUserCommentList(userId: String) // TODO: 다른 유저의 Comment List 가져올 필요
    case createComment(socialId: Int, parentCommentId: Int?, content: String, imageUrl: String?)
    case updateComment(comment: Comment) // TODO: Comment 수정 기능 구현 필요 (NEED BACKEND)
    case deleteComment(commentId: String) // TODO: Comment 삭제 기능 구현 필요
    case reportComment(commentId: String) // TODO: Comment 신고 기능 구현 필 (NEED BACKEND)
    case blockComment(commentId: String) // TODO: Comment 차단 기능 구현 필요
    
    case fetchUser(userId: String) // TODO: 다른 유저의 정보 가져오는 기능 구현 필요 (NEED BACKEND)
    case fetchUserDetail(userId: String) // TODO: 다른 유저의 상세 정보 가져오는 기능 구현 필요 (NEED BACKEND)
    case fetchUserPostList(userId: String) // TODO: 다른 유저의 Post List 가져오는 기능 구현 필요 (NEED BACKEND)
    case fetchUserRoutineList(userId: String) // TODO: 다른 유저의 Routine List 가져오는 기능 구현 필요 (NEED BACKEND)
    case fetchUserShareUrl(userId: String) // 이게 뭐지?
    case toggleUserFollow(userId: String, targetUserId: String) // TODO: Follow 기능 구현 필요
}

extension SocialAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchPostList:
            "v1/socials"
        case .searchPost:
            "v1/socials/search"
        case .likePost(let postId):
            "v1/socials/\(postId)/likes"
        case .unlikePost(let postId):
            "v1/socials/\(postId)/likes"
        case .createPost:
            "/v1/socials"
        case .updatePost(let post):
            "/posts/\(post.id)"
        case .deletePost(let postId):
            "v1/socials/\(postId)"
        case .fetchPost(let postId):
            "v1/socials/\(postId)"
        case .reportPost(let postId):
            "/posts/\(postId)/report"
        case .blockUser(let blockUser):
            "v1/users/\(blockUser)/block"
        case .toggleCommentLike(let commentId):
            "/comments/\(commentId)/like"
        case .fetchUserCommentList(let userId):
            "/users/\(userId)/comments"
        case .createComment(let socialId, _, _, _):
            "v1/socials/\(socialId)/comments"
        case .updateComment(let comment):
            "/comments/\(comment.id)"
        case .deleteComment(let commentId):
            "/comments/\(commentId)"
        case .reportComment(let commentId):
            "/comments/\(commentId)/report"
        case .blockComment(let commentId):
            "/comments/\(commentId)/block"
        case .fetchUser(let userId):
            "/users/\(userId)"
        case .fetchUserDetail(let userId):
            "/users/\(userId)/detail"
        case .fetchUserPostList(let userId):
            "/users/\(userId)/posts"
        case .fetchUserRoutineList(let userId):
            "/users/\(userId)/routines"
        case .fetchUserShareUrl(let userId):
            "/users/\(userId)/share-url"
        case .toggleUserFollow(let userId, let targetUserId):
            "/users/\(userId)/follow/\(targetUserId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchPostList,
             .searchPost,
             .fetchPost,
             .fetchUserCommentList,
             .fetchUser,
             .fetchUserDetail,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchUserShareUrl:
            .get
        case .likePost,
             .createPost,
             .reportPost,
             .blockUser,
             .toggleCommentLike,
             .createComment,
             .reportComment,
             .blockComment,
             .toggleUserFollow:
            .post
        case .updatePost, .updateComment:
            .put
        case .deletePost, .deleteComment, .unlikePost:
            .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchPostList(let cursor, let limit, let categoryIds):
            var params: [String: Any] = ["limit": limit]
            if let cursor {
                params["cursor"] = cursor
            }
            if let categoryIds {
                params["categoryIds"] = categoryIds.map { String($0) }.joined(separator: ",")
            }
            return params
        case .searchPost(let keyword, let cursor, let limit):
            var params: [String: Any] = ["keyword": keyword, "limit": limit]
            if let cursor {
                params["cursor"] = cursor
            }
            return params
        case .likePost,
             .unlikePost,
             .fetchPost,
             .reportPost,
             .blockUser,
             .toggleCommentLike,
             .fetchUserCommentList,
             .fetchUser,
             .fetchUserDetail,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchUserShareUrl,
             .deletePost,
             .deleteComment,
             .createPost,
             .updatePost,
             .createComment,
             .updateComment,
             .toggleUserFollow,
             .reportComment,
             .blockComment:
            // TODO: - API에 따라 이 부분도 구현되어야 합니다.
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchPostList,
             .searchPost,
             .likePost,
             .unlikePost,
             .fetchPost,
             .reportPost,
             .blockUser,
             .toggleCommentLike,
             .fetchUserCommentList,
             .fetchUser,
             .fetchUserDetail,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchUserShareUrl,
             .deletePost,
             .deleteComment:
            return .requestPlain
        case .createPost(let post):
            let params: [String: Any?] = [
                "title": post.title,
                "content": post.content,
                "routineId": post.routineId,
                "isAnonymous": post.isAnonymous,
                "socialCategoryIds": post.socialCategoryIds,
                "socialImageUrls": post.socialImageUrls
            ]
            
            return .requestParameters(parameters: params.compactMapValues { $0 })
        case .updatePost(let post):
            return .requestPlain
        case .createComment(let socialId, let parentCommentId, let content, let imageUrl):
            let params: [String: Any?] = [
                "imageUrl": imageUrl,
                "parentId": parentCommentId,
                "content": content,
            ]
            return .requestParameters(parameters: params.compactMapValues { $0 })
        case .updateComment(let comment):
            return .requestPlain
        case .toggleUserFollow:
            return .requestPlain
        case .reportComment(commentId: let commentId):
            return .requestPlain
        case .blockComment(commentId: let commentId):
            return .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        let jsonHeader: MFHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
        ]
        
        // TODO: - 논의 후 결정?
        
        return jsonHeader
    }
}
