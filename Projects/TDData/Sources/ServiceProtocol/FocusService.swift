public protocol FocusService {
    func saveFocus(date: String, targetCount: Int, settingCount: Int, time: Int) async throws
    func fetchFocusPercent(yearMonth: String) async throws -> FocusPercentResponseDTO
    func fetchFocusList(yearMonth: String) async throws -> FocusListResponseDTO
}
