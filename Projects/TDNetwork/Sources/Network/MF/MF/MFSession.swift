import Foundation
import TDCore
import TDData

open class MFSession {
    public static let `default` = MFSession()
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public convenience init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        let session = URLSession(configuration: configuration)
        self.init(session: session)
    }
    
    @discardableResult
    open func request(_ request: MFRequest) async throws(MFError) -> MFResponse<Data> {
        let response = try await perform(request) { data in
            data
        }
        
        return response
    }
    
    @discardableResult
    open func requestString(_ request: MFRequest) async throws(MFError) -> MFResponse<String> {
        let response = try await perform(request) { data in
            guard let string = String(data: data, encoding: .utf8) else { throw MFError.requestStringEncodingFailure }
            return string
        }
        
        return response
    }
    
    @discardableResult
    open func requestDecodable<T: Decodable>(of type: T.Type, _ request: MFRequest) async throws(MFError) -> MFResponse<T> {
        let response = try await perform(request) { data in
            let decoder = JSONDecoder()
            TDLogger.debug("디코딩할 타입: \(ServerResponse<T>.self)\n디코딩할 데이터: \(String(data: data, encoding: .utf8) ?? "")")
            let serverResponse = try decoder.decode(ServerResponse<T>.self, from: data)
            TDLogger.debug("\(serverResponse.code), \(String(describing: serverResponse.message))")
            guard (20000 ... 29999).contains(serverResponse.code) else {
                if let apiError = APIError(rawValue: serverResponse.code) {
                    throw MFError.serverError(apiError: apiError)
                } else {
                    throw MFError.serverErrorCode(code: serverResponse.code, message: serverResponse.message)
                }
            }
            guard let content = serverResponse.content else { throw MFError.requestDecodableDecodingFailure }
            return content
        }
        return response
    }

    @discardableResult
    open func requestJSON(_ request: MFRequest) async throws(MFError) -> MFResponse<[String: Any]> {
        let response = try await perform(request) { data in
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { throw MFError.requestJSONDecodingFailure }
                return json
            } catch {
                throw MFError.requestJSONDecodingFailure
            }
        }
        
        return response
    }
    
    func perform<T>(
        _ request: MFRequest,
        transformer: @escaping (Data) throws -> T,
        retryCount: Int = 1
    ) async throws(MFError) -> MFResponse<T> {
        if let error = request.error {
            throw error
        }
        
        do {
            let urlRequest = try request.asURLRequest()
            let (data, response) = try await session.data(for: urlRequest)
            let transformedData = try transformer(data)
            
            let mfResponse = try MFResponse(
                request: request.asURLRequest(),
                response: response,
                value: transformedData
            )
            
            return mfResponse
        } catch {
            if let mfError = error.asMFError {
                TDLogger.network("Network 오류가 발생했습니다. \(#file), \(#filePath)를 참고해주세요.\n \(mfError.description)")
                if case let MFError.serverError(apiError) = mfError {
                    switch apiError {
                    case .expiredAccessToken:
                        if retryCount > 0 {
                            try await refreshToken()
                            return try await perform(request, transformer: transformer, retryCount: retryCount - 1)
                        } else {
                            throw mfError
                        }
                    case .emptyAccessToken,
                         .malformedToken,
                         .tamperedToken,
                         .unsupportedJWTToken,
                         .takenAwayToken,
                         .expiredRefreshToken:
                        NotificationCenter.default.post(name: .userRefreshTokenExpired, object: nil)
                        throw mfError
                    default:
                        throw mfError
                    }
                }
                throw mfError
            } else {
                throw MFError.networkFailure(underlyingError: error)
            }
        }
    }

    private func refreshToken() async throws(MFError) {
        let provider = MFProvider<AuthAPI>()
        guard let refreshToken = TDTokenManager.shared.refreshToken else {
            throw MFError.serverError(apiError: .expiredRefreshToken)
        }
        let target = AuthAPI.refreshToken(refreshToken: refreshToken)
        let response = try await provider.requestDecodable(of: LoginUserResponseBody.self, target)
        guard let refreshToken = response.extractRefreshToken(),
              let refreshTokenExpiredAt = response.extractRefreshTokenExpiry()
        else {
            throw MFError.requestJSONDecodingFailure
        }
        try? await TDTokenManager.shared.saveToken((
            accessToken: response.value.accessToken,
            refreshToken: refreshToken,
            refreshTokenExpiredAt: refreshTokenExpiredAt,
            userId: response.value.userId
        ))
    }
}

public struct EmptyResponse: Decodable { }
