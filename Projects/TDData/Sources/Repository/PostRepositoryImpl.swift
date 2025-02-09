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
        id: nil,
        title: "123",
        category: TDCategory(
            colorHex: "#123456",
            imageName: "computer"
        ),
        isAllDay: false,
        isPublic: true,
        date: Date(),
        time: nil,
        repeatDays: nil,
        alarmTimes: nil,
        memo: nil,
        recommendedRoutines: nil,
        isFinished: false
    )
    private let dummyUser = User(id: UUID(), name: "", icon: "", title: "", isblock: false)
    private var dummyPost = Post.dummy

    public init() { }

    public func fetchPostList(category: PostCategory?) async throws -> [Post] {
        guard let category = category else {
            return dummyPost
        }
        return dummyPost
            .filter { $0.category?.contains(category) ?? false }
    }

    public func searchPost(keyword: String, category: PostCategory?) async throws -> [Post]? {
        guard let category = category else {
            return dummyPost
                .filter { $0.contentText.contains(keyword) }
        }
        return dummyPost
            .filter { $0.contentText.contains(keyword) && $0.category?.contains(category) ?? false }
    }

    public func togglePostLike(postID: Post.ID) async throws -> Result<Post, Error> {
        if let index = dummyPost.firstIndex(where: { $0.id == postID }) {
            dummyPost[index].toggleLike()
            return .success(dummyPost[index])
        }
        //TODO: 실제 리소스에 반영 후 적절한 Error 처리 필요
        return .failure(NSError(domain: "PostRepositoryImpl", code: 0, userInfo: nil))
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
        guard let post = dummyPost.filter({ $0.id == postID }).first else {
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
