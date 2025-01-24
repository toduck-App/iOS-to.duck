//
//  MFSession.swift
//  TDNetwork
//
//  Created by 디해 on 1/8/25.
//

import Foundation

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
            return data
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
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw MFError.requestDecodableDecodingFailure
            }
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
    
    func perform<T>(_ request: MFRequest, transformer: @escaping (Data) throws -> T) async throws(MFError) -> MFResponse<T> {
        if let error = request.error {
            throw error
        }
        
        do {
            let urlRequest = try request.asURLRequest()
            let (data, response) = try await session.data(for: urlRequest)
            let transformedData = try transformer(data)
            
            let mfResponse = MFResponse(
                request: try request.asURLRequest(),
                response: response,
                value: transformedData
            )
            return mfResponse
        } catch {
            if let error = error.asMFError {
                throw error
            } else {
                let error = MFError.networkFailure(underlyingError: error)
                throw error
            }
        }
    }
}
