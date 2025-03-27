import Foundation

public protocol AwsService {
    func requestPresignedUrl(fileName: String) async throws -> URL
    func requestUploadImage(url: URL, data: Data) async throws
}
