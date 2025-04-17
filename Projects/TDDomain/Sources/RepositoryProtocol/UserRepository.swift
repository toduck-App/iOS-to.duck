import Foundation

public protocol UserRepository {
    func fetchUser(userID: User.ID) async throws -> (User, UserDetail)
    func fetchUserPostList(userID: User.ID, cursor: Int?, limit: Int) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func fetchUserRoutineList(userID: User.ID) async throws -> [Routine]?
    func fetchUserShareUrl(userID: User.ID) async throws -> String
    func followUser(targetUserID: User.ID) async throws
    func unFollowUser(targetUserID: User.ID) async throws
    func blockUser(userID: User.ID) async throws
    
    func shareRoutine(routineID: Routine.ID, routine: Routine) async throws
}
