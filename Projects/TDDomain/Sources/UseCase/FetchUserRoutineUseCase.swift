import Foundation

public protocol FetchUserRoutineUseCase {
    func execute(user: User) async throws -> [Routine]?
}

public final class FetchUserRoutineUseCaseImpl: FetchUserRoutineUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(user: User) async throws -> [Routine]? {
        return try await repostiory.fetchUserRoutineList(userId: user.id)
    }
}
