import Foundation
import TDCore
import TDData
import TDDomain

public enum SocialAPI {
    case fetchPostList(curser: Int?, limit: Int, categoryIds: [Int]?)
    case searchPost(keyword: String, cursor: Int?, limit: Int, categoryIds: [Int]?)
    case likePost(postId: Int)
    case unlikePost(postId: Int)
    case createPost(post: TDPostCreateRequestDTO)
    case updatePost(post: TDPostUpdateRequestDTO)
    case deletePost(postId: Int)
    case fetchPost(postId: String)
    case reportPost(postId: Int, reportType: String, reason: String?, blockAuthor: Bool)
    case blockUser(userId: Int)
    case unBlockUser(userId: Int)
    case fetchBlockedUserList
    
    case likeComment(postId: Int, commentId: Int)
    case unlikeComment(postId: Int, commentId: Int)
    
    case fetchMyCommentList(cursor: Int?, limit: Int) // TODO: 다른 유저의 Comment List 가져올 필요
    case createComment(socialId: Int, parentCommentId: Int?, content: String, imageUrl: String?)
    case updateComment(comment: Comment) // TODO: Comment 수정 기능 구현 필요 (NEED BACKEND)
    case deleteComment(postId: Int, commentId: Int)
    case reportComment(postId: Int, commentId: Int, reportType: String, reason: String?, blockAuthor: Bool)
    case fetchUser(userId: Int)
    case fetchUserPostList(userId: Int, cursor: Int?, limit: Int)
    case fetchUserRoutineList(userId: Int)
    
    case followUser(targetUserId: Int)
    case unfollowUser(targetUserId: Int)
    
    case shareRoutine(routineId: Int, dto: RoutineRequestDTO)
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
            "v1/socials/\(post.id)"
        case .deletePost(let postId):
            "v1/socials/\(postId)"
        case .fetchPost(let postId):
            "v1/socials/\(postId)"
        case .reportPost(let postId, _, _, _):
            "v1/socials/\(postId)/report"
        case .blockUser(let blockUser):
            "v1/users/\(blockUser)/block"
        case .unBlockUser(let blockUser):
            "v1/users/\(blockUser)/block"
        case .likeComment(let postId, let commentId):
            "v1/socials/\(postId)/comments/\(commentId)/likes"
        case .unlikeComment(let postId, let commentId):
            "v1/socials/\(postId)/comments/\(commentId)/likes"
        case .fetchMyCommentList:
            "v1/my-page/comments"
        case .createComment(let socialId, _, _, _):
            "v1/socials/\(socialId)/comments"
        case .updateComment(let comment):
            "/comments/\(comment.id)"
        case .deleteComment(let postId, let commentId):
            "v1/socials/\(postId)/comments/\(commentId)"
        case .reportComment(let postId, let commentId, _, _, _):
            "v1/socials/\(postId)/comments/\(commentId)/report"
        case .fetchUser(let userId):
            "v1/profiles/\(userId)"
        case .fetchUserPostList(let userId, _, _):
            "v1/profiles/\(userId)/socials"
        case .fetchUserRoutineList(let userId):
            "v1/profiles/\(userId)/routines"
        case .followUser(let targetUserId):
            "v1/users/\(targetUserId)/follow"
        case .unfollowUser(let targetUserId):
            "v1/users/\(targetUserId)/follow"
        case .shareRoutine(let routineId, _):
            "v1/profiles/shared-routines/\(routineId)"
        case .fetchBlockedUserList:
            "v1/my-page/blocked-users"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchPostList,
             .searchPost,
             .fetchPost,
             .fetchMyCommentList,
             .fetchUser,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchBlockedUserList:
            .get
        case .likePost,
             .createPost,
             .reportPost,
             .blockUser,
             .likeComment,
             .createComment,
             .reportComment,
             .followUser,
             .shareRoutine:
            .post
        case .updatePost, .updateComment:
            .patch
        case .deletePost, .deleteComment, .unlikePost, .unfollowUser, .unlikeComment, .unBlockUser:
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
        case .searchPost(let keyword, let cursor, let limit, let categoryIds):
            var params: [String: Any] = ["keyword": keyword, "limit": limit]
            if let cursor {
                params["cursor"] = cursor
            }
            if let categoryIds {
                params["categoryIds"] = categoryIds.map { String($0) }.joined(separator: ",")
            }
            return params
        case .fetchUserPostList(_, let cursor, let limit):
            var params: [String: Any] = ["limit": limit]
            if let cursor {
                params["cursor"] = cursor
            }
            return params
        case .fetchMyCommentList(let cursor, let limit):
            var params: [String: Any] = ["limit": limit]
            if let cursor {
                params["cursor"] = cursor
            }
            return params
        case .shareRoutine,
             .reportPost,
             .likePost,
             .unlikePost,
             .fetchPost,
             .blockUser,
             .unBlockUser,
             .likeComment,
             .unlikeComment,
             .fetchUser,
             .fetchUserRoutineList,
             .deletePost,
             .deleteComment,
             .createPost,
             .updatePost,
             .createComment,
             .updateComment,
             .followUser,
             .unfollowUser,
             .reportComment,
             .fetchBlockedUserList:
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
             .blockUser,
             .unBlockUser,
             .likeComment,
             .unlikeComment,
             .fetchMyCommentList,
             .fetchUser,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .deletePost,
             .deleteComment,
             .followUser,
             .unfollowUser,
             .fetchBlockedUserList:
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
        case .updatePost(let dto):
            let params: [String: Any?] = [
                "isChangeTitle": dto.isChangeTitle,
                "title": dto.title,
                "isChangeRoutine": dto.isChangeRoutine,
                "routineId": dto.routineId,
                "content": dto.content,
                "isAnonymous": dto.isAnonymous,
                "socialCategoryIds": dto.socialCategoryIds,
                "socialImageUrls": dto.socialImageUrls
            ]
            return .requestParameters(parameters: params.compactMapValues { $0 })
        case .createComment(let socialId, let parentCommentId, let content, let imageUrl):
            let params: [String: Any?] = [
                "imageUrl": imageUrl,
                "parentId": parentCommentId,
                "content": content
            ]
            return .requestParameters(parameters: params.compactMapValues { $0 })
        case .reportPost(_, let reportType, let reason, let blockAuthor):
            var params: [String: Any] = ["reportType": reportType]
            if let reason {
                params["reason"] = reason
            }
            params["blockAuthor"] = blockAuthor
            return .requestParameters(parameters: params.compactMapValues { $0 })
        case .updateComment(let comment):
            return .requestPlain
        case .reportComment(_, _, let reportType, let reason, let blockAuthor):
            var params: [String: Any] = ["reportType": reportType]
            if let reason {
                params["reason"] = reason
            }
            params["blockAuthor"] = blockAuthor
            return .requestParameters(parameters: params.compactMapValues { $0 })
        case .shareRoutine(_, let routine):
            return .requestParameters(parameters: [
                "title": routine.title,
                "category": routine.category,
                "color": routine.color,
                "time": routine.time ?? "",
                "isPublic": routine.isPublic,
                "daysOfWeek": routine.daysOfWeek.map { $0 } ?? [],
                "reminderMinutes": routine.reminderMinutes ?? 0,
                "memo": routine.memo ?? ""
            ])
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
