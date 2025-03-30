public protocol MyPageRepository {
    func fetchNickname() async throws -> String
    func updateNickname(nickname: String) async throws
}
