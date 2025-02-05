//
//  SocialCommentRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation
import TDDomain
import TDCore
public final class CommentRepositoryImpl: CommentRepository {
    private var comments: [Comment] = Comment.dummy
    public init() {}
    
    public func toggleCommentLike(commentID: Comment.ID) async throws -> Result<Comment, Error> {
        for index in comments.indices {
            // 댓글인 경우
            if comments[index].id == commentID {
                comments[index].toggleLike()
            }
            // 대댓글인 경우
            if let replyIndex = comments[index].reply.firstIndex(where: { $0.id == commentID }) {
                comments[index].reply[replyIndex].toggleLike()
            }
            return .success(comments[index])
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
    
    public func createComment(comment: Comment) async throws -> Bool {
        false
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
}
