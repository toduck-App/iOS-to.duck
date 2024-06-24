//
//  SocialCommentRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public final class CommentRepository: CommentRepositoryProtocol {


    public init() {}
    
    public func toggleCommentLike(commentId: String) async throws -> Bool {
        return false
    }
    
    public func fetchCommentList(commentId: String) async throws -> [Comment]? {
        return []
    }
    
    public func fetchUserCommentList(userId: String) async throws -> [Comment]? {
        return []
    }
    
    public func createComment(comment: Comment) async throws -> Bool {
        return false
    }
    
    public func updateComment(comment: Comment) async throws -> Bool {
        return false
    }
    
    public func deleteComment(commentId: String) async throws -> Bool {
        return false
    }
    
    public func reportComment(commentId: String) async throws -> Bool {
        return false
    }
    
    public func blockComment(commentId: String) async throws -> Bool {
        return false
    }
}