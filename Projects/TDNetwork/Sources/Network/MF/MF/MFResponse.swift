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

extension MFResponse {
    public func extractRefreshToken() -> String? {
        guard let headers = self.httpResponse?.allHeaderFields else { return nil }
        guard let setCookie = headers["Set-Cookie"] as? String else { return nil }

        let components = setCookie.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        for component in components {
            if component.hasPrefix("refreshToken=") {
                return component.replacingOccurrences(of: "refreshToken=", with: "")
            }
        }
        return nil
    }
    
    public func extractRefreshTokenExpiry() -> String? {
        guard let headers = self.httpResponse?.allHeaderFields else { return nil }
        guard let setCookie = headers["Set-Cookie"] as? String else { return nil }
        
        let components = setCookie.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        for component in components {
            if component.hasPrefix("Expires=") {
                return component.replacingOccurrences(of: "Expires=", with: "")
            }
        }
        return nil
    }
}
