//
//  MFResponse.swift
//  TDNetwork
//
//  Created by 디해 on 1/10/25.
//

import Foundation

public struct MFResponse<T> {
    public let request: URLRequest?
    
    public let response: URLResponse?
    
    public var httpResponse: HTTPURLResponse? { response as? HTTPURLResponse }
    
    public var value: T
    
    public init(
        request: URLRequest?,
        response: URLResponse?,
        value: T
    ) {
        self.request = request
        self.response = response
        self.value = value
    }
}
