public protocol FocusService {
    func fetchFocusPercent(yearMonth: String) async throws -> FocusPercentResponseDTO
    func fetchFocusList(yearMonth: String) async throws -> FocusListResponseDTO
}
