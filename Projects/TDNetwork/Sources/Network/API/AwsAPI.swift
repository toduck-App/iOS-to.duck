import Foundation
import TDCore

public enum AwsAPI {
    case presignedUrl(fileName: String)
    case uploadImage(url: URL, data: Data)
}

extension AwsAPI: MFTarget {
    public var baseURL: URL {
        switch self {
        case .presignedUrl(let fileName):
            URL(string: APIConstants.baseURL)!
        case .uploadImage(let url, _):
            url
        }
    }
    
    public var path: String {
        switch self {
        case .presignedUrl:
            "/v1/presigned"
        case .uploadImage:
            ""
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .presignedUrl:
            .post
        case .uploadImage:
            .put
        }
    }
    
    public var queries: Parameters? {
        nil
    }
    
    public var task: MFTask {
        switch self {
        case .presignedUrl(let fileName):
            .requestParameters(
                parameters: ["fileNameDtos": [["fileName": fileName]]]
            )
        case .uploadImage(_, let data):
            .requestParameters(
                parameters: ["image": data]
            )
        }
    }
    
    public var headers: MFHeaders? {
        switch self {
        case .presignedUrl: [
                .contentType("application/json"),
                .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
            ]
        case .uploadImage: [
                .contentType("image/jpeg")
            ]
        }
    }
}
