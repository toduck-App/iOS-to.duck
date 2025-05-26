import TDDomain
import Foundation

public struct MyPageRepositoryImpl: MyPageRepository {
    private let service: MyPageService
    private let awsService: AwsService
    
    public init(service: MyPageService, awsService: AwsService) {
        self.service = service
        self.awsService = awsService
    }
    
    public func fetchNickname() async throws -> String {
        try await service.fetchNickname()
    }
    
    public func updateNickname(nickname: String) async throws {
        try await service.updateNickname(nickname: nickname)
    }
    
    public func updateProfileImage(image: (fileName: String, imageData: Data)?) async throws {
        var imageUrl: String?
        if let image {
            let urls = try await awsService.requestPresignedUrl(fileName: image.fileName)
            try await awsService.requestUploadImage(url: urls.presignedUrl, data: image.imageData)
            imageUrl = urls.fileUrl.absoluteString
        }
        
        try await service.updateProfileImage(url: imageUrl)
    }
    
}
