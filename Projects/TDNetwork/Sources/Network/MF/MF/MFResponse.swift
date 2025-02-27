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
