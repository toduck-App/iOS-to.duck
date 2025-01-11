import Foundation

public protocol FetchUserRoutineUseCase {
    func execute(userID: User.ID) async throws -> [Routine]?
}

public final class FetchUserRoutineUseCaseImpl: FetchUserRoutineUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(userID: User.ID) async throws -> [Routine]? {
        return try await repostiory.fetchUserRoutineList(userID: userID)
    }
}
