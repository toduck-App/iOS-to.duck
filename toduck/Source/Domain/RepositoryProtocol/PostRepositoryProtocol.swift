//
//  PostRepositroyProtocol.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public protocol PostRepositoryProtocol {
    
    func fetchPostList(type: PostType, category: PostCategory) async throws -> [Post]
    func searchPost(keyword: String,type: PostType,category: PostCategory) async throws -> [Post]?
    func togglePostLike(postId: String) async throws -> Bool
    func bringUserRoutine(routine: Routine) async throws -> Routine
    
    //MARK: - Post CRUD
    func createPost(post: Post) async throws -> Bool
    func updatePost(post: Post) async throws -> Bool
    func deletePost(postId: String) async throws -> Bool
    func fetchPost(postId: String) async throws -> Post
    func reportPost(postId: String) async throws -> Bool
    func blockPost(postId: String) async throws -> Bool
}

