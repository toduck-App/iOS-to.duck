//
//  MFProvider.swift
//  TDNetwork
//
//  Created by 디해 on 1/22/25.
//

import Foundation

open class MFProvider<Target: MFTarget> {
    private let session: MFSession
    
    public init(session: MFSession = .default) {
        self.session = session
    }
    
    @discardableResult
    open func request(_ target: Target) async throws(MFError) -> MFResponse<Data> {
        let request = target.toRequest()
        
        return try await session.request(request)
    }
    
    @discardableResult
    open func requestString(_ target: Target) async throws(MFError) -> MFResponse<String> {
        let request = target.toRequest()
        
        return try await session.requestString(request)
    }
    
    @discardableResult
    open func requestDecodable<T: Decodable>(of type: T.Type, _ target: Target) async throws(MFError) -> MFResponse<T> {
        let request = target.toRequest()
        
        return try await session.requestDecodable(of: type, request)
    }
    
    @discardableResult
    open func requestJSON(_ target: Target) async throws(MFError) -> MFResponse<[String: Any]> {
        let request = target.toRequest()
        
        return try await session.requestJSON(request)
    }
}
