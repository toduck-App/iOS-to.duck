public protocol FocusService {
    func fetchFocusPrecent(yearMonth: String) async throws -> FocusPercentResponseDTO
    func fetchFocusList(yearMonth: String) async throws -> FocusListResponseDTO
}
