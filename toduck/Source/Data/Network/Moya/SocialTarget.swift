//
//  SocialTarget.swift
//  toduck
//
//  Created by 승재 on 7/9/24.
//

import Foundation
import Moya

enum SocialTarget {
    case fetchPostList(type: PostType, category: PostCategory)
    case searchPost(keyword: String, type: PostType, category: PostCategory)
    case togglePostLike(postId: String)
    case bringUserRoutine(routine: Routine)
    case createPost(post: Post)
    case updatePost(post: Post)
    case deletePost(postId: String)
    case fetchPost(postId: String)
    case reportPost(postId: String)
    case blockPost(postId: String)
    
    case toggleCommentLike(commentId: String)
    case fetchCommentList(commentId: String)
    case fetchUserCommentList(userId: String)
    case createComment(comment: Comment)
    case updateComment(comment: Comment)
    case deleteComment(commentId: String)
    case reportComment(commentId: String)
    case blockComment(commentId: String)
    
    case fetchUser(userId: String)
    case fetchUserDetail(userId: String)
    case fetchUserPostList(userId: String)
    case fetchUserRoutineList(userId: String)
    case fetchUserShareUrl(userId: String)
    case toggleUserFollow(userId: String, targetUserId: String)
}

extension SocialTarget: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .fetchPostList:
            return "/posts"
        case .searchPost:
            return "/posts/search"
        case .togglePostLike(let postId):
            return "/posts/\(postId)/like"
        case .bringUserRoutine(let routine):
            return "/routines/\(routine.id)"
        case .createPost:
            return "/posts"
        case .updatePost(let post):
            return "/posts/\(post.id)"
        case .deletePost(let postId):
            return "/posts/\(postId)"
        case .fetchPost(let postId):
            return "/posts/\(postId)"
        case .reportPost(let postId):
            return "/posts/\(postId)/report"
        case .blockPost(let postId):
            return "/posts/\(postId)/block"
        
        case .toggleCommentLike(let commentId):
            return "/comments/\(commentId)/like"
        case .fetchCommentList(let commentId):
            return "/comments/\(commentId)"
        case .fetchUserCommentList(let userId):
            return "/users/\(userId)/comments"
        case .createComment:
            return "/comments"
        case .updateComment(let comment):
            return "/comments/\(comment.id)"
        case .deleteComment(let commentId):
            return "/comments/\(commentId)"
        case .reportComment(let commentId):
            return "/comments/\(commentId)/report"
        case .blockComment(let commentId):
            return "/comments/\(commentId)/block"
        
        case .fetchUser(let userId):
            return "/users/\(userId)"
        case .fetchUserDetail(let userId):
            return "/users/\(userId)/detail"
        case .fetchUserPostList(let userId):
            return "/users/\(userId)/posts"
        case .fetchUserRoutineList(let userId):
            return "/users/\(userId)/routines"
        case .fetchUserShareUrl(let userId):
            return "/users/\(userId)/share-url"
        case .toggleUserFollow(let userId, let targetUserId):
            return "/users/\(userId)/follow/\(targetUserId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchPostList, 
             .searchPost,
             .fetchPost,
             .fetchCommentList,
             .fetchUserCommentList,
             .fetchUser,
             .fetchUserDetail,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchUserShareUrl,
             .bringUserRoutine:
            return .get
        case .togglePostLike, 
             .createPost,
             .reportPost,
             .blockPost,
             .toggleCommentLike,
             .createComment,
             .reportComment,
             .blockComment,
             .toggleUserFollow:
            return .post
        case .updatePost, .updateComment:
            return .put
        case .deletePost, .deleteComment:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .fetchPostList(let type, let category):
            return .requestParameters(parameters: ["type": type, "category": category.rawValue], encoding: URLEncoding.queryString)
        case .searchPost(let keyword, let type, let category):
            return .requestParameters(parameters: ["keyword": keyword, "type": type, "category": category.rawValue], encoding: URLEncoding.queryString)
        case .togglePostLike,
             .fetchPost,
             .reportPost,
             .blockPost,
             .toggleCommentLike,
             .fetchCommentList,
             .fetchUserCommentList,
             .fetchUser,
             .fetchUserDetail,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchUserShareUrl,
             .bringUserRoutine,
             .deletePost,
             .deleteComment:
            return .requestPlain
        case .createPost(let post), .updatePost(let post):
            // 수정 필요
            return .requestPlain
        case .createComment(let comment), .updateComment(let comment):
            return .requestPlain
        case .toggleUserFollow(_, _):
            return .requestPlain
        case .reportComment(commentId: let commentId):
            return .requestPlain
        case .blockComment(commentId: let commentId):
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
//        if let accessToken = TokenManager.shared.accessToken {
//            headers["Authorization"] = "Bearer \(accessToken)"
//        }
        return headers
    }
}
