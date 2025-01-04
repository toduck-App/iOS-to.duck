//
//  SocialCommentRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import TDDomain
import Foundation

public final class CommentRepositoryImpl: CommentRepository {
    public init() { }
    
    public func toggleCommentLike(commentID: Comment.ID) async throws -> Bool {
        return false
    }
    
    public func fetchCommentList(postID: Post.ID) async throws -> [Comment]? {
        return Comment.dummy
    }
    
    public func fetchCommentList(commentID: Comment.ID) async throws -> [Comment]? {
        return []
    }
    
    public func fetchUserCommentList(userID: User.ID) async throws -> [Comment]? {
        return []
    }
    
    public func createComment(comment: Comment) async throws -> Bool {
        return false
    }
    
    public func updateComment(comment: Comment) async throws -> Bool {
        return false
    }
    
    public func deleteComment(commentID: Comment.ID) async throws -> Bool {
        return false
    }
    
    public func reportComment(commentID: Comment.ID) async throws -> Bool {
        return false
    }
    
    public func blockComment(commentID: Comment.ID) async throws -> Bool {
        return false
    }
}
