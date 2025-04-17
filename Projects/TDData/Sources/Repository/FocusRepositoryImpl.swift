import TDDomain

struct FocusRepositoryImpl: FocusRepository {
    private let service: FocusService
    
    init(service: FocusService) {
        self.service = service
    }
    
    func fetchFocusPercent(yearMonth: String) async throws -> Int {
        let response = try await service.fetchFocusPercent(yearMonth: yearMonth)
        return response.percent
    }
    
    func fetchFocusList(yearMonth: String) async throws -> [Focus] {
        let response = try await service.fetchFocusList(yearMonth: yearMonth)
        let focusList = response.convertToFocusList()
        
        return focusList
    }
}
