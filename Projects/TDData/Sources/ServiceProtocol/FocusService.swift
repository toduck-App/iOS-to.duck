public protocol FocusService {
    func fetchFocusPrecent(yearMonth: String) async throws -> FocusPercentResponseDTO
}
