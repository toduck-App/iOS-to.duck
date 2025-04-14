import TDDomain

struct FocusRepositoryImpl: FocusRepository {
    private let service: FocusService
    
    init(service: FocusService) {
        self.service = service
    }
    
    func fetchFocusPercent(yearMonth: String) async throws -> Int {
        let response = try await service.fetchFocusPrecent(yearMonth: yearMonth)
        return response.percent
    }
}
