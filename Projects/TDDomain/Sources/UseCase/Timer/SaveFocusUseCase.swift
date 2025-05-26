public protocol SaveFocusUseCase {
    func execute(date: String, targetCount: Int, settingCount: Int, time: Int) async throws
}

public final class SaveFocusUseCaseImpl: SaveFocusUseCase {
    private let repository: FocusRepository
    
    public init(repository: FocusRepository) {
        self.repository = repository
    }
    
    public func execute(date: String, targetCount: Int, settingCount: Int, time: Int) async throws {
        try await repository.saveFocus(date: date, targetCount: targetCount, settingCount: settingCount, time: time)
    }
}
