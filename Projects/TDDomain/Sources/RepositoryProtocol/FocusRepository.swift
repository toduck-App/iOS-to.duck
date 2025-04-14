public protocol FocusRepository {
    func fetchFocusPercent() async throws -> Int
}
