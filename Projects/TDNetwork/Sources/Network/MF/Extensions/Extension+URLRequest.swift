import Foundation

extension URLRequest {
    public init(
        url: MFURLConvertible,
        method: MFHTTPMethod,
        queries: Queries? = nil,
        parameters: Parameters? = nil,
        headers: MFHeaders? = nil
    ) throws {
        let originalURL = try url.asURL()
        
        guard var components = URLComponents(url: originalURL, resolvingAgainstBaseURL: false) else {
            throw MFError.invalidURL
        }
        
        if components.path.hasSuffix("/") {
            components.path = String(components.path.dropLast())
        }
        
        if let queries {
            var queryItems = components.queryItems ?? []
            try queryItems.append(contentsOf: queries.map { key, value in
                guard let stringValue = Self.convertToValidString(value) else {
                    throw MFError.invalidQueryValue(key: key, value: value)
                }
                return URLQueryItem(name: key, value: stringValue)
            })
            components.queryItems = queryItems
        }
        
        guard let newURL = components.url else {
            throw MFError.invalidURL
        }
        
        self.init(url: newURL)
        httpMethod = method.rawValue
        
        if let params = parameters {
            let contentType = headers?.dictionary["Content-Type"] ?? "application/json"
            switch contentType {
            case "application/json":
                httpBody = try Self.validateAndSerializeJSON(params)
            case "application/x-www-form-urlencoded":
                httpBody = try Self.encodeFormURLEncoded(params)
            case "image/jpeg":
                httpBody = params["image"] as? Data
            default:
                throw MFError.invalidContentType
            }
        }
        
        if let headersDict = headers?.dictionary {
            for (key, value) in headersDict {
                setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    private static func validateAndSerializeJSON(_ params: [String: Any]) throws -> Data {
        guard JSONSerialization.isValidJSONObject(params) else {
            throw MFError.jsonSerializationFailure
        }
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            throw MFError.jsonSerializationFailure
        }
        return data
    }
    
    private static func encodeFormURLEncoded(_ params: [String: Any]) throws -> Data {
        let parameterString = try params.map { key, value -> String in
            guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let encodedValue = Self.convertToValidString(value)
            else {
                throw MFError.urlEncodingFailure
            }
            return "\(encodedKey)=\(encodedValue)"
        }.joined(separator: "&")
        
        guard let data = parameterString.data(using: .utf8) else {
            throw MFError.urlEncodingFailure
        }
        return data
    }
    
    private static func convertToValidString(_ value: Any) -> String? {
        if let stringValue = value as? String {
            return stringValue
        } else if let numberValue = value as? NSNumber {
            return "\(numberValue)"
        } else if let boolValue = value as? Bool {
            return boolValue ? "true" : "false"
        }
        return nil
    }
}
