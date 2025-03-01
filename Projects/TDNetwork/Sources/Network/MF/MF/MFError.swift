import Foundation

extension Error {
    public var asMFError: MFError? {
        self as? MFError
    }
}

public enum MFError: Error, CustomStringConvertible {
    case invalidURL
    case invalidContentType
    case networkFailure(underlyingError: Error)
    case parameterEncodingFailure
    case requestStringEncodingFailure
    case requestJSONDecodingFailure
    case requestDecodableDecodingFailure
    case jsonSerializationFailure
    case urlEncodingFailure
    case invalidQueryValue(key: String, value: Any)
    
    public var description: String {
        switch self {
        case .invalidURL:
            return "Error: The URL provided is invalid."
        case .invalidContentType:
            return "Error: Content type is invalid."
        case .networkFailure(let underlyingError):
            return "Error: Network failure occurred - \(underlyingError.localizedDescription)"
        case .parameterEncodingFailure:
            return "Error: Failed to encode parameters."
        case .requestStringEncodingFailure:
            return "Error: Failed to encode the data to string."
        case .requestJSONDecodingFailure:
            return "Error: Failed to decode the data to JSON."
        case .requestDecodableDecodingFailure:
            return "Error. Failed to decode the data to decodable."
        case .jsonSerializationFailure:
            return "Error: Expected a serializable dictionary but got something else."
        case .urlEncodingFailure:
            return "Error: Failed to encode parameters to url encoded data."
        case .invalidQueryValue(key: let key, value: let value):
            return "Error: Invalid parameter - \(key): \(value)"
        }
    }
}
