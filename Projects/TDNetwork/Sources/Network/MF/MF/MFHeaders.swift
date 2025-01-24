//
//  MFHeaders.swift
//  TDNetwork
//
//  Created by 디해 on 1/8/25.
//

import Foundation

public struct MFHeader {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

public struct MFHeaders {
    private var headers: [MFHeader] = []
    
    public init() { }
    
    public init(_ dictionary: [String: String]) {
        dictionary.forEach {
            let header = MFHeader(name: $0.key, value: $0.value)
            headers.append(header)
        }
    }
    
    public var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }
        
        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
    
    public mutating func merge(with other: MFHeaders) -> Self {
        other.headers.forEach { newHeader in
            headers.removeAll(where: { $0.name == newHeader.name })
            headers.append(newHeader)
        }
        
        return self
    }
}

extension MFHeader {
    public static func authorization(bearerToken: String) -> MFHeader {
        return MFHeader(name: "Authorization", value: "Bearer \(bearerToken)")
    }
    
    public static func accept(_ value: String) -> MFHeader {
        return MFHeader(name: "Accept", value: value)
    }
    
    public static func contentType(_ value: String) -> MFHeader {
        return MFHeader(name: "Content-Type", value: value)
    }
}

extension MFHeaders: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = MFHeader
    
    public init(arrayLiteral elements: MFHeader...) {
        self.headers = elements
    }
}
