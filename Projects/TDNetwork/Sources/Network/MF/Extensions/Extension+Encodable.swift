//
//  Extension+Codable.swift
//  TDNetwork
//
//  Created by 디해 on 1/10/25.
//

import Foundation

extension Encodable {
    public func asDictionary() throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let dictionary = jsonObject as? [String: Any] else { throw MFError.parameterEncodingFailure }
            
            return dictionary
        } catch {
            throw MFError.parameterEncodingFailure
        }
    }
}
