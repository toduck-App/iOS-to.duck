public protocol UpdateDiaryUseCase {
    func execute(isChangeEmotion: Bool, diary: Diary) async throws
}

public final class UpdateDiaryUseCaseImpl: UpdateDiaryUseCase {
    private let repository: DiaryRepository

    public init(repository: DiaryRepository) {
        self.repository = repository
    }

    public func execute(isChangeEmotion: Bool, diary: Diary) async throws {
        try await repository.updateDiary(isChangeEmotion: isChangeEmotion, diary: diary)
    }
}
