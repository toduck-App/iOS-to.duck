//
//  CommentRepositoryProtocol.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public protocol CommentRepository {
    func toggleCommentLike(commentID: Comment.ID) async throws -> Result<Comment, Error> 
    func reportComment(commentID: Comment.ID) async throws -> Bool
    func blockComment(commentID: Comment.ID) async throws -> Bool
    
    func fetchCommentList(postID: Post.ID) async throws -> [Comment]?
    func fetchCommentList(commentID: Comment.ID) async throws -> [Comment]?
    func fetchUserCommentList(userID: User.ID) async throws -> [Comment]?
    func createComment(comment: NewComment) async throws -> Bool
    func updateComment(comment: Comment) async throws -> Bool
    func deleteComment(commentID: Comment.ID) async throws -> Bool
}
