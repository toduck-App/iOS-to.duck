import Foundation

public protocol UserRepository {
    func fetchUser(userID: User.ID) async throws -> (User, UserDetail)
    func fetchUserPostList(userID: User.ID) async throws -> [Post]?
    func fetchUserRoutineList(userID: User.ID) async throws -> [Routine]?
    func fetchUserShareUrl(userID: User.ID) async throws -> String
    func toggleUserFollow(userID: User.ID,targetUserID: User.ID) async throws -> Bool
    func blockUser(userID: User.ID) async throws
}
