public protocol FocusRepository {
    func fetchFocusPercent(yearMonth: String) async throws -> Int
    func fetchFocusList(yearMonth: String) async throws -> [Focus]
}
