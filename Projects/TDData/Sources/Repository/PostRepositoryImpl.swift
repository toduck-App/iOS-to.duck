//
//  SocialPostRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import TDDomain
import Foundation

public final class PostRepositoryImpl: PostRepository {
    private let dummyRoutine = Routine(
        id: UUID(),
        title: "123",
        category: TDCategory(
            colorHex: "#123456",
            imageType: .computer
        ),
        isAllDay: false,
        isPublic: true,
        date: Date(),
        time: nil,
        repeatDays: nil,
        alarmTimes: nil,
        memo: nil,
        recommendedRoutines: nil,
        isFinish: false
    )
    private let dummyUser = User(id: UUID(), name: "", icon: "", title: "", isblock: false)

    public init() { }

    public func fetchPostList(category: PostCategory?) async throws -> [Post] {
        guard let category = category else {
            return Post.dummy.sorted { $0.timestamp > $1.timestamp }
        }
        return Post.dummy
            .filter { $0.category?.contains(category) ?? false }
            .sorted { $0.timestamp > $1.timestamp }
    }

    public func searchPost(keyword: String, category: PostCategory) async throws -> [Post]? {
        return []
    }

    public func togglePostLike(postID: Post.ID) async throws -> Bool {
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

    public func deletePost(postID: Post.ID) async throws -> Bool {
        return false;
    }

    public func fetchPost(postID: Post.ID) async throws -> Post {
        guard let post = Post.dummy.filter({ $0.id == postID }).first else {
            // 에러 정의가 없어서 임시로 구현
            return Post.dummy[0]
        }
        return post
    }

    public func reportPost(postID: Post.ID) async throws -> Bool {
        return false;
    }

    public func blockPost(postID: Post.ID) async throws -> Bool {
        return false;
    }
}
