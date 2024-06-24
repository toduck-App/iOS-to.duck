//
//  SocialPostRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public final class PostRepository: PostRepositoryProtocol {
    private let dummyRoutine = Routine(id: 0, title: "", isPublic: false, isRepeating: false, isRepeatAllDay: false, alarm: false, isFinish: false)
    private let dummyUser = User(id: "", name: "", icon: "", title: "", isblock: false)

    public init() {}

    public func fetchPostList(type: PostType, category: PostCategory) async throws -> [Post] {
        return []
    }

    public func searchPost(keyword: String, type: PostType, category: PostCategory) async throws -> [Post]? {
        return []
    }

    public func togglePostLike(postId: String) async throws -> Bool {
        return false;
    }

    public func bringUserRoutine(routine: Routine) async throws -> Routine {
        return dummyRoutine
    }

    public func createPost(post: Post) async throws -> Bool {
        return false;
    }

    public func updatePost(post: Post) async throws -> Bool {
        return false;
    }

    public func deletePost(postId: String) async throws -> Bool {
        return false;   
    }

    public func fetchPost(postId: String) async throws -> Post {
        return Post(id: "", user: dummyUser, contentText: "", imageList: [], timestamp: Date(), likeCount: 0, isLike: false, commentCount: 0, shareCount: 0, routine: dummyRoutine, type: .communication, category: .none);
    }

    public func reportPost(postId: String) async throws -> Bool {
        return false;
    }

    public func blockPost(postId: String) async throws -> Bool {
        return false;
    }


}