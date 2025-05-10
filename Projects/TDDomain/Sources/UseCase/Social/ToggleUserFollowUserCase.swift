import Foundation

public protocol ToggleUserFollowUseCase {
    func execute(currentFollowState: Bool, targetUserID: User.ID) async throws
}

public final class ToggleUserFollowUseCaseImpl: ToggleUserFollowUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(currentFollowState: Bool, targetUserID: User.ID) async throws {
        if currentFollowState {
            try await repository.unFollowUser(targetUserID: targetUserID)
        } else {
            try await repository.followUser(targetUserID: targetUserID)
        }
    }
}
