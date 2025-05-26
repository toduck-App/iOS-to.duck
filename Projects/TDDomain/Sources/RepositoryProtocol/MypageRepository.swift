import Foundation

public protocol MyPageRepository {
    func fetchNickname() async throws -> String
    func updateNickname(nickname: String) async throws
    func updateProfileImage(image: (fileName: String, imageData: Data)?) async throws
}
