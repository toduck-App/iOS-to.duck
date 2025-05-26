@testable import TDDomain

final class MockFetchUserUseCase: FetchUserUseCase {
    var stubbedIsFollowing: [Int: Bool] = [:]
    var executedUserIDs: [Int] = []

    func execute(id: User.ID) async throws -> (User, UserDetail) {
        executedUserIDs.append(id)
        let isFollowing = stubbedIsFollowing[id] ?? false
        return (
            User(id: id, name: "MockUser", icon: nil, title: "제목"),
            UserDetail(
                isFollowing: isFollowing,
                followingCount: 0,
                followerCount: 0,
                totalPostCount: 0,
                totalCommentCount: 0,
                totalRoutineCount: 0,
                isMe: false
            )
        )
    }
}
