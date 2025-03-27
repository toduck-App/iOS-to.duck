import Foundation
import TDData
import TDCore
import TDDomain

public enum SocialAPI {
    case fetchPostList(category: PostCategory)
    case searchPost(keyword: String, category: PostCategory)
    case togglePostLike(postId: String)
    case bringUserRoutine(routine: Routine)
    case createPost(post: TDPostCreateRequestDTO)
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

extension SocialAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchPostList:
            "/posts"
        case .searchPost:
            "/posts/search"
        case .togglePostLike(let postId):
            "/posts/\(postId)/like"
        case .bringUserRoutine(let routine):
            "/routines/\(routine.id)"
        case .createPost:
            "/v1/socials"
        case .updatePost(let post):
            "/posts/\(post.id)"
        case .deletePost(let postId):
            "/posts/\(postId)"
        case .fetchPost(let postId):
            "v1/socials/\(postId)"
        case .reportPost(let postId):
            "/posts/\(postId)/report"
        case .blockPost(let postId):
            "/posts/\(postId)/block"
        case .toggleCommentLike(let commentId):
            "/comments/\(commentId)/like"
        case .fetchCommentList(let commentId):
            "/comments/\(commentId)"
        case .fetchUserCommentList(let userId):
            "/users/\(userId)/comments"
        case .createComment:
            "/comments"
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
             .fetchCommentList,
             .fetchUserCommentList,
             .fetchUser,
             .fetchUserDetail,
             .fetchUserPostList,
             .fetchUserRoutineList,
             .fetchUserShareUrl,
             .bringUserRoutine:
            .get
        case .togglePostLike,
             .createPost,
             .reportPost,
             .blockPost,
             .toggleCommentLike,
             .createComment,
             .reportComment,
             .blockComment,
             .toggleUserFollow:
            .post
        case .updatePost, .updateComment:
            .put
        case .deletePost, .deleteComment:
            .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchPostList(let category):
            ["category": category.rawValue]
        case .searchPost(let keyword, let category):
            ["keyword": keyword, "category": category.rawValue]
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
             .deleteComment,
             .createPost,
             .updatePost,
             .createComment,
             .updateComment,
             .toggleUserFollow,
             .reportComment,
             .blockComment:
            // TODO: - API에 따라 이 부분도 구현되어야 합니다.
            nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchPostList,
             .searchPost,
             .togglePostLike,
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
        case  .updatePost(let post):
            return .requestPlain
        case .createComment(let comment), .updateComment(let comment):
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

public extension SocialAPI {
    var sampleData: Data {
        switch self {
        case .fetchPostList:
            """
            [
                {
                    "id": 1,
                    "user": {
                        "id": 1,
                        "name": "toduck",
                        "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                        "title": "작심삼일",
                        "isblock": false
                    },
                    "contentText": "테스트 게시물 내용입니다.",
                    "imageList": ["https://geojecci.korcham.net/images/no-image01.gif", "https://geojecci.korcham.net/images/no-image01.gif"],
                    "timestamp": "2024-07-10T09:00:00Z",
                    "likeCount": 10,
                    "isLike": true,
                    "commentCount": 5,
                    "shareCount": 2,
                    "routine": null,
                    "type": "communication",
                    "category": ["집중력", "기억력"]
                }
            ]
            """.data(using: .utf8)!
        case .searchPost:
            """
            [
                {
                    "id": 2,
                    "user": {
                        "id": 2,
                        "name": "toduck2",
                        "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                        "title": "작심삼일",
                        "isblock": false
                    },
                    "contentText": "테스트 게시물",
                    "imageList": ["https://geojecci.korcham.net/images/no-image01.gif"],
                    "timestamp": "2024-07-11T09:00:00Z",
                    "likeCount": 5,
                    "isLike": false,
                    "commentCount": 2,
                    "shareCount": 1,
                    "routine": null,
                    "type": "question",
                    "category": ["충동"]
                }
            ]
            """.data(using: .utf8)!
        case .togglePostLike:
            """
            {
                "success": true
            }
            """.data(using: .utf8)!
        case .bringUserRoutine:
            """
            {
                "id": 1,
                "title": "아침 루틴",
                "category": "건강",
                "isPublic": true,
                "dateAndTime": "2024-07-10T07:00:00Z",
                "isRepeating": true,
                "isRepeatAllDay": false,
                "repeatDays": ["월", "수", "금"],
                "alarm": true,
                "alarmTimes": ["60"],
                "memo": "스트레칭으로 시작하기",
                "recommendedRoutines": ["달리기", "요가"],
                "isFinish": false
            }
            """.data(using: .utf8)!
        case .createPost, .updatePost:
            """
            {
                "id": 3,
                "user": {
                    "id": 3,
                    "name": "toduck3",
                    "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                    "title": "작심삼일",
                    "isblock": false
                },
                "contentText": "테스트 새로운 게시물입니다.",
                "imageList": ["https://geojecci.korcham.net/images/no-image01.gif"],
                "timestamp": "2024-07-12T09:00:00Z",
                "likeCount": 0,
                "isLike": false,
                "commentCount": 0,
                "shareCount": 0,
                "routine": null,
                "type": "communication",
                "category": ["불안"]
            }
            """.data(using: .utf8)!
        case .deletePost:
            """
            {
                "success": true
            }
            """.data(using: .utf8)!
        case .fetchPost:
            """
            {
                "id": 1,
                "user": {
                    "id": 1,
                    "name": "toduck",
                    "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                    "title": "작심삼일",
                    "isblock": false
                },
                "contentText": "테스트 게시물 내용입니다.",
                "imageList": ["https://geojecci.korcham.net/images/no-image01.gif", "https://geojecci.korcham.net/images/no-image01.gif"],
                "timestamp": "2024-07-10T09:00:00Z",
                "likeCount": 10,
                "isLike": true,
                "commentCount": 5,
                "shareCount": 2,
                "routine": null,
                "type": "communication",
                "category": ["집중력", "기억력"]
            }
            """.data(using: .utf8)!
        case .reportPost, .blockPost:
            """
            {
                "success": true
            }
            """.data(using: .utf8)!
        case .toggleCommentLike, .fetchCommentList, .fetchUserCommentList, .createComment, .updateComment, .deleteComment, .reportComment, .blockComment:
            """
            {
                "id": 1,
                "user": {
                    "id": 1,
                    "name": "toduck",
                    "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                    "title": "작심삼일",
                    "isblock": false
                },
                "content": "테스트 댓글입니다.",
                "timestamp": "2024-07-10T09:00:00Z",
                "isLike": true,
                "like": 5
            }
            """.data(using: .utf8)!
        case .fetchUser, .fetchUserDetail:
            """
            {
                "id": 1,
                "name": "toduck",
                "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                "title": "작심삼일",
                "isblock": false
            }
            """.data(using: .utf8)!
        case .fetchUserPostList:
            """
            [
                {
                    "id": 1,
                    "user": {
                        "id": 1,
                        "name": "toduck",
                        "icon": "https://geojecci.korcham.net/images/no-image01.gif",
                        "title": "작심삼일",
                        "isblock": false
                    },
                    "contentText": "테스트 게시물 내용입니다.",
                    "imageList": ["https://geojecci.korcham.net/images/no-image01.gif", "https://geojecci.korcham.net/images/no-image01.gif"],
                    "timestamp": "2024-07-10T09:00:00Z",
                    "likeCount": 10,
                    "isLike": true,
                    "commentCount": 5,
                    "shareCount": 2,
                    "routine": null,
                    "type": "communication",
                    "category": ["집중력", "기억력"]
                }
            ]
            """.data(using: .utf8)!
        case .fetchUserRoutineList:
            """
            [
                {
                    "id": 1,
                    "title": "아침 루틴",
                    "category": "건강",
                    "isPublic": true,
                    "dateAndTime": "2024-07-10T07:00:00Z",
                    "isRepeating": true,
                    "isRepeatAllDay": false,
                    "repeatDays": ["월", "수", "금"],
                    "alarm": true,
                    "alarmTimes": ["60"],
                    "memo": "스트레칭으로 시작하기",
                    "recommendedRoutines": ["달리기", "요가"],
                    "isFinish": false
                }
            ]
            """.data(using: .utf8)!
        case .fetchUserShareUrl:
            """
            {
                "url": "https://example.com/share/user1"
            }
            """.data(using: .utf8)!
        case .toggleUserFollow:
            """
            {
                "success": true
            }
            """.data(using: .utf8)!
        }
    }
}
