public protocol FocusRepository {
    func saveFocus(date: String, targetCount: Int, settingCount: Int, time: Int) async throws
    func fetchFocusPercent(yearMonth: String) async throws -> Int
    func fetchFocusList(yearMonth: String) async throws -> [Focus]
}
