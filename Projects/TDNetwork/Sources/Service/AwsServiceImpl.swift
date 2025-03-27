import Foundation
import TDCore
import TDData

public struct AwsServiceImpl: AwsService {
    private let provider: MFProvider<AwsAPI>

    public init(provider: MFProvider<AwsAPI> = MFProvider<AwsAPI>()) {
        self.provider = provider
    }

    public func requestPresignedUrl(fileName: String) async throws -> URL {
        let response = try await provider.requestDecodable(of: PresignedUrlResponseDTO.self, .presignedUrl(fileName: fileName))
        guard let presignedUrl = response.value.fileUrlsDtos.first?.presignedUrl, let url = URL(string: presignedUrl) else {
            throw TDDataError.parsingError
        }
        return url
    }

    public func requestUploadImage(url: URL, data: Data) async throws {
        let response = try await provider.requestString(.uploadImage(url: url, data: data))}
}
