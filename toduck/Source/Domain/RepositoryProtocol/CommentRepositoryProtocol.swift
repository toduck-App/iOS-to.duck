//
//  CommentRepositoryProtocol.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public protocol CommentRepositoryProtocol {
    func toggleCommentLike(commentId: String) async throws -> Bool

    func fetchCommentList(commentId: String) async throws -> [Comment]?
    func fetchUserCommentList(userId: String) async throws -> [Comment]?
    //MARK: - Comment CRUD
    func createComment(comment: Comment) async throws -> Bool
    func updateComment(comment: Comment) async throws -> Bool
    func deleteComment(commentId: String) async throws -> Bool
    func reportComment(commentId: String) async throws -> Bool
    func blockComment(commentId: String) async throws -> Bool
}
