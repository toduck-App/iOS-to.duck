public protocol MyPageService {
    func fetchNickname() async throws -> String
    func updateNickname(nickname: String) async throws
}
