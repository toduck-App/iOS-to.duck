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
        
        var capturedData: Data? = nil
        var capturedResponse: URLResponse? = nil
        let id = request.id
        
        do {
            let urlRequest = try request.asURLRequest()
            for plugin in plugins {
                plugin.willSend(request: urlRequest, id: id)
            }
            
            let (data, response) = try await session.data(for: urlRequest)
            capturedData = data
            capturedResponse = response
            
            for plugin in plugins {
                plugin.didReceive(response: response, data: data, for: urlRequest, id: id)
            }
            
            let transformedData = try transformer(data)
            
            let mfResponse = try MFResponse(
                request: request.asURLRequest(),
                response: response,
                value: transformedData
            )
            
            return mfResponse
        } catch {
            for plugin in plugins {
                plugin.didFail(error: error, request: request.request, response: capturedResponse, data: capturedData, id: id)
            }
            
            if let mfError = error.asMFError {
                if case let MFError.serverError(apiError) = mfError {
                    switch apiError {
                    case .expiredAccessToken:
                        if retryCount > 0 {
                            do {
                                try await TDTokenRefresher.shared.refreshTokens()
                            } catch let error as MFError {
                                throw error
                            } catch {
                                throw MFError.networkFailure(underlyingError: error)
                            }
                            
                            if let newAccessToken = TDTokenManager.shared.accessToken {
                                request.addHeaders([.authorization(bearerToken: newAccessToken)])
                            }
                            
                            return try await perform(request, transformer: transformer, retryCount: retryCount - 1)
                        } else {
                            NotificationCenter.default.post(name: .userRefreshTokenExpired, object: nil)
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
}

public struct EmptyResponse: Decodable {}
