//
//  MFHTTPMethod.swift
//  TDNetwork
//
//  Created by 디해 on 1/8/25.
//

import Foundation

public struct MFHTTPMethod {
    public static let get = MFHTTPMethod(rawValue: "GET")
    
    public static let post = MFHTTPMethod(rawValue: "POST")
    
    public static let put = MFHTTPMethod(rawValue: "PUT")
    
    public static let delete = MFHTTPMethod(rawValue: "DELETE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
