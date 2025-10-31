import Foundation
import TDDomain

public protocol SocialService {
    func requestPosts(cursor: Int?, limit: Int, categoryIDs: [Int]?) async throws -> TDPostListDTO
    func requestSearchPosts(cursor: Int?, limit: Int, keyword: String, categoryIDs: [Int]?) async throws -> TDPostListDTO

    func requestLikePost(postID: Post.ID) async throws
    func requestUnlikePost(postID: Post.ID) async throws

    func requestCreatePost(requestDTO: TDPostCreateRequestDTO) async throws -> TDPostCreateResponseDTO
    func requestUpdatePost(requestDTO: TDPostUpdateRequestDTO) async throws
    func requestDeletePost(postID: Post.ID) async throws

    func requestPost(postID: Post.ID) async throws -> TDPostDTO
    
    func requestCreateComment(socialId: Int, content: String, parentId: Int?, imageUrl: String?) async throws -> Int
    func requestLikeComment(postID: Post.ID, commentID: Comment.ID) async throws
    func requestUnlikeComment(postID: Post.ID, commentID: Comment.ID) async throws
    func requestRemoveComment(postID: Post.ID, commentID: Comment.ID) async throws

    func requestReportPost(postID: Post.ID, reportType: String, reason: String?, blockAuthor: Bool) async throws
    func requestReportComment(postID: Post.ID, commentID: Comment.ID, reportType: String, reason: String?, blockAuthor: Bool) async throws
}
