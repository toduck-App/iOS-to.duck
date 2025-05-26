import Foundation

public struct MFHTTPMethod {
    public static let get = MFHTTPMethod(rawValue: "GET")
    
    public static let post = MFHTTPMethod(rawValue: "POST")
    
    public static let put = MFHTTPMethod(rawValue: "PUT")
    
    public static let delete = MFHTTPMethod(rawValue: "DELETE")
    
    public static let patch = MFHTTPMethod(rawValue: "PATCH")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
