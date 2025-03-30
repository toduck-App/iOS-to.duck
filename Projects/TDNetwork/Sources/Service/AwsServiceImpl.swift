import Foundation
import TDCore
import TDData

public struct AwsServiceImpl: AwsService {
    private let provider: MFProvider<AwsAPI>

    public init(provider: MFProvider<AwsAPI> = MFProvider<AwsAPI>()) {
        self.provider = provider
    }

    public func requestPresignedUrl(fileName: String) async throws -> (presignedUrl: URL, fileUrl: URL) {
        let response = try await provider.requestDecodable(of: PresignedUrlResponseDTO.self, .presignedUrl(fileName: fileName))
        guard let dtos = response.value.fileUrlsDtos.first,
              let presignedUrl = URL(string: dtos.presignedUrl),
              let fileUrl = URL(string: dtos.fileUrl)
                else {
            throw TDDataError.parsingError
        }
        return (presignedUrl, fileUrl)
    }

    public func requestUploadImage(url: URL, data: Data) async throws {
        let response = try await provider.requestString(.uploadImage(url: url, data: data))}
}
