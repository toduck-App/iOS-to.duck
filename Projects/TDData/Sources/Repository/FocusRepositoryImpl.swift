import TDDomain

struct FocusRepositoryImpl: FocusRepository {
    private let service: FocusService
    
    init(service: FocusService) {
        self.service = service
    }
    
    func fetchFocusPercent() async throws -> Int {
        try await service.fetchFocusPrecent()
    }
}
