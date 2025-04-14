public protocol FocusRepository {
    func fetchFocusPercent(yearMonth: String) async throws -> Int
}
