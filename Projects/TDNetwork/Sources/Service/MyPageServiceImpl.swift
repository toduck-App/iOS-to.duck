import TDData

struct MyPageServiceImpl: MyPageService {
    private let provider: MFProvider<MyPageAPI>
    
    init(provider: MFProvider<MyPageAPI> = MFProvider<MyPageAPI>()) {
        self.provider = provider
    }
    
    func fetchNickname() async throws -> String {
        let target = MyPageAPI.fetchNickname
        let nickname = try await provider.requestDecodable(of: UserNicknameResponseDTO.self, target).value.nickname
        
        return nickname
    }
    
    func updateNickname(nickname: String) async throws {
        let target = MyPageAPI.updateNickname(nickname: nickname)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    func updateProfileImage(url: String?) async throws {
        let target = MyPageAPI.updateProfileImage(urlString: url)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
}
