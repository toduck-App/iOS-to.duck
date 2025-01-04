import Foundation

public protocol FetchUserDetailUseCase {
    func execute(id: User.ID) async throws -> UserDetail
}

public final class FetchUserDetailUseCaseImpl: FetchUserDetailUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(id: User.ID) async throws -> UserDetail {
        try await repostiory.fetchUserDetail(userId: id)
    }
}
