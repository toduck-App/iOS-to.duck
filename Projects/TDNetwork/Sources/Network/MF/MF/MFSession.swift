import Foundation
import TDCore
import TDData

public actor MFSession {
    public static let `default` = MFSession(plugins: [
        MFNetworkLoggerPlugin(),
    ])
    
    public let session: URLSession
    private let plugins: [MFNetworkPlugin]
    
    public init(session: URLSession, plugins: [MFNetworkPlugin] = []) {
        self.session = session
        self.plugins = plugins
    }
    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default, plugins: [MFNetworkPlugin] = []) {
        let session = URLSession(configuration: configuration)
        self.init(session: session, plugins: plugins)
    }
    
    @discardableResult
    public func request(_ request: MFRequest) async throws(MFError) -> MFResponse<Data> {
        let response = try await perform(request) { data in
            data
        }
        
        return response
    }
    
    @discardableResult
    public func requestString(_ request: MFRequest) async throws(MFError) -> MFResponse<String> {
        let response = try await perform(request) { data in
            guard let string = String(data: data, encoding: .utf8) else { throw MFError.requestStringEncodingFailure }
            return string
        }
        
        return response
    }
    
    @discardableResult
    public func requestDecodable<T: Decodable>(of type: T.Type, _ request: MFRequest) async throws(MFError) -> MFResponse<T> {
        let response = try await perform(request) { data in
            let decoder = JSONDecoder()
            let serverResponse = try decoder.decode(ServerResponse<T>.self, from: data)
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
    public func requestJSON(_ request: MFRequest) async throws(MFError) -> MFResponse<[String: Any]> {
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
            return try await executeAndTransformRequest(
                request,
                transformer: transformer
            )
        } catch {
            return try await handleError(
                error,
                for: request,
                transformer: transformer,
                retryCount: retryCount
            )
        }
    }
    
    /// URLRequest를 생성하고, 네트워크 요청을 보내고, 성공적인 응답 데이터를 transformer를 사용해 변환합니다.
    private func executeAndTransformRequest<T>(
        _ request: MFRequest,
        transformer: @escaping (Data) throws -> T
    ) async throws -> MFResponse<T> {
        let urlRequest = try request.asURLRequest()
        plugins.forEach { $0.willSend(request: urlRequest, id: request.id) }
        
        let (data, response) = try await session.data(for: urlRequest)
        plugins.forEach { $0.didReceive(response: response, data: data, for: urlRequest, id: request.id) }
        let transformedData = try transformer(data)
        
        return MFResponse(
            request: urlRequest,
            response: response,
            value: transformedData
        )
    }
    
    /// 발생한 에러를 분석하고, 재시도가 필요한 경우와 그렇지 않은 경우를 구분하여 처리합니다.
    private func handleError<T>(
        _ error: Error,
        for request: MFRequest,
        transformer: @escaping (Data) throws -> T,
        retryCount: Int
    ) async throws(MFError) -> MFResponse<T> {
        plugins.forEach { $0.didFail(error: error, request: request.request, response: nil, data: nil, id: request.id) }
        
        guard let mfError = error as? MFError else {
            throw MFError.networkFailure(underlyingError: error)
        }
        
        // 서버 에러 + Access Token 만료인 경우 재시도 로직 호출
        if case .serverError(.expiredAccessToken) = mfError {
            return try await retryRequestAfterTokenRefresh(
                request,
                transformer: transformer,
                retryCount: retryCount
            )
        }
        
        handleSideEffects(for: mfError)
        throw mfError
    }
    
    /// Access Token 만료 시 토큰을 갱신하고 원래 요청을 재시도합니다.
    private func retryRequestAfterTokenRefresh<T>(
        _ request: MFRequest,
        transformer: @escaping (Data) throws -> T,
        retryCount: Int
    ) async throws(MFError) -> MFResponse<T> {
        
        guard retryCount > 0 else {
            // 재시도 횟수 소진 시 로그아웃 알림 후 에러 발생
            NotificationCenter.default.post(name: .userRefreshTokenExpired, object: nil)
            throw MFError.serverError(apiError: .expiredAccessToken)
        }
        
        // 토큰 갱신 시도
        do {
            try await TDTokenRefresher.shared.refreshTokens()
        } catch {
            NotificationCenter.default.post(name: .userRefreshTokenExpired, object: nil)
            throw MFError.networkFailure(underlyingError: error)
        }
        
        if let newAccessToken = TDTokenManager.shared.accessToken {
            request.addHeaders([.authorization(bearerToken: newAccessToken)])
        }
        
        return try await perform(
            request,
            transformer: transformer,
            retryCount: retryCount - 1
        )
    }
    
    private func handleSideEffects(for error: MFError) {
        guard case .serverError(let apiError) = error else { return }
        
        switch apiError {
        case .emptyAccessToken,
                .malformedToken,
                .tamperedToken,
                .unsupportedJWTToken,
                .takenAwayToken,
                .expiredRefreshToken:
            NotificationCenter.default.post(name: .userRefreshTokenExpired, object: nil)
        default:
            break
        }
    }
}

public struct EmptyResponse: Decodable {}
