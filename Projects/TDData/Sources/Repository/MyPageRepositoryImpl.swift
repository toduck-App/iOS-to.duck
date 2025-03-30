import TDDomain

public struct MyPageRepositoryImpl: MyPageRepository {
    private let service: MyPageService
    
    public init(service: MyPageService) {
        self.service = service
    }
    
    public func fetchNickname() async throws -> String {
        try await service.fetchNickname()
    }
    
    public func updateNickname(nickname: String) async throws {
        try await service.updateNickname(nickname: nickname)
    }
}
