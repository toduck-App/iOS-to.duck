import Foundation

public protocol UpdateProfileImageUseCase {
    func execute(image: (fileName: String, imageData: Data)?) async throws
}

public final class UpdateProfileImageUseCaseImpl: UpdateProfileImageUseCase {
    private let repository: MyPageRepository

    public init(repository: MyPageRepository) {
        self.repository = repository
    }

    public func execute(image: (fileName: String, imageData: Data)?) async throws {
        try await repository.updateProfileImage(image: image)
    }
}
