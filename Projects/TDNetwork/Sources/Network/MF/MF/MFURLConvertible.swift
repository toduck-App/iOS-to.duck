//
//  MFURLConvertible.swift
//  TDNetwork
//
//  Created by 디해 on 1/8/25.
//

import Foundation

public protocol MFURLConvertible {
    func asURL() throws -> URL
}

extension String: MFURLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw MFError.invalidURL }
        
        return url
    }
}

extension URL: MFURLConvertible {
    public func asURL() throws -> URL { self }
}

extension URLComponents: MFURLConvertible {
    public func asURL() throws -> URL {
        guard let url else { throw MFError.invalidURL }
        
        return url
    }
}
