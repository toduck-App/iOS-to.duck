import Foundation

public protocol FetchUserRoutineUseCase {
    func execute(user: User) async throws -> [Routine]?
}

public final class FetchUserRoutineUseCaseImpl: FetchUserRoutineUseCase {
    private let repostiory: UserRepository

    public init(repostiory: UserRepository) {
        self.repostiory = repostiory
    }

    public func execute(user: User) async throws -> [Routine]? {
        return try await repostiory.fetchUserRoutineList(userId: user.id)
    }
}
