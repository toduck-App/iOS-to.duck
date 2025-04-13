import Foundation

public protocol UpdateDiaryUseCase {
    func execute(isChangeEmotion: Bool, diary: Diary, image: [(fileName: String, imageData: Data)]?) async throws
}

public final class UpdateDiaryUseCaseImpl: UpdateDiaryUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }

    public func execute(
        isChangeEmotion: Bool,
        diary: Diary,
        image: [(fileName: String, imageData: Data)]?
    ) async throws {
        try await repository.updateDiary(isChangeEmotion: isChangeEmotion, diary: diary, image: image)
    }
}
