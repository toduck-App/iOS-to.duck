//
//  SocialPostRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import TDDomain
import Foundation

public final class PostRepositoryImpl: PostRepository {
    private let dummyRoutine = Routine(id: UUID(), title: "123", category: TDCategory(colorType: .back1, imageType: .computer), isAllDay: false, isPublic: true, date: Date(), time: nil, repeatDays: nil, alarmTimes: nil, memo: nil, recommendedRoutines: nil, isFinish: false)
    private let dummyUser = User(id: 0, name: "", icon: "", title: "", isblock: false)

    public init() { }

    public func fetchPostList(type: PostType, category: PostCategory) async throws -> [Post] {
        if category == .all {
            return Post.dummy
                .filter { $0.type == type }
                .sorted { $0.timestamp > $1.timestamp }
        }
        return Post.dummy
            .filter { $0.type == type && $0.category?.contains(category) ?? false }
            .sorted { $0.timestamp > $1.timestamp }
    }

    public func searchPost(keyword: String, type: PostType, category: PostCategory) async throws -> [Post]? {
        return []
    }

    public func togglePostLike(postId: Int) async throws -> Bool {
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

    public func deletePost(postId: Int) async throws -> Bool {
        return false;
    }

    public func fetchPost(postId: Int) async throws -> Post {
        guard let post = Post.dummy.filter({ $0.id == postId }).first else {
            // 에러 정의가 없어서 임시로 구현
            return Post.dummy[0]
        }
        return post
    }

    public func reportPost(postId: Int) async throws -> Bool {
        return false;
    }

    public func blockPost(postId: Int) async throws -> Bool {
        return false;
    }
}
