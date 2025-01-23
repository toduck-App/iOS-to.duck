//
//  Extension+URLRequest.swift
//  TDNetwork
//
//  Created by 디해 on 1/8/25.
//

import Foundation

extension URLRequest {
    public init(
        url: MFURLConvertible,
        method: MFHTTPMethod,
        queries: Queries? = nil,
        parameters: Parameters? = nil,
        headers: MFHeaders? = nil
    ) throws {
        let url = try url.asURL()
        
        self.init(url: url)
        
        if let queries {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { throw MFError.invalidURL }
            var queryItems = components.queryItems ?? []
            queryItems.append(contentsOf: try queries.map { key, value in
                guard let stringValue = convertToValidString(value) else { throw MFError.invalidQueryValue(key: key, value: value) }
                return URLQueryItem(name: key, value: stringValue)
            })
            components.queryItems = queryItems
            
            guard let newURL = components.url else { throw MFError.invalidURL }
            self.url = newURL
        }
        
        httpMethod = method.rawValue
        
        if let params = parameters {
            let contentType = headers?.dictionary["Content-Type"] ?? "application/json"
                
            switch contentType {
            case "application/json":
                httpBody = try validateAndSerializeJSON(params)
                    
            case "application/x-www-form-urlencoded":
                httpBody = try encodeFormURLEncoded(params)
                    
            default:
                throw MFError.invalidContentType
            }
        }
        
        allHTTPHeaderFields = headers?.dictionary
    }
    
    private func validateAndSerializeJSON(_ params: [String: Any]) throws -> Data {
        guard JSONSerialization.isValidJSONObject(params) else {
            throw MFError.jsonSerializationFailure
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            throw MFError.jsonSerializationFailure
        }
        
        return data
    }
    
    private func encodeFormURLEncoded(_ params: [String: Any]) throws -> Data {
        let parameterString = try params.map { key, value -> String in
            guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let encodedValue = convertToValidString(value) else {
                throw MFError.urlEncodingFailure
            }
            return "\(encodedKey)=\(encodedValue)"
        }.joined(separator: "&")
        
        guard let data = parameterString.data(using: .utf8) else {
            throw MFError.urlEncodingFailure
        }
        return data
    }

    private func convertToValidString(_ value: Any) -> String? {
        if let stringValue = value as? String {
            return stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        } else if let numberValue = value as? NSNumber {
            return "\(numberValue)"
        } else if let boolValue = value as? Bool {
            return boolValue ? "true" : "false"
        }
        return nil
    }
}
