import Foundation

public extension Error {
    var asMFError: MFError? {
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
    case unauthorized
    case serverError(apiError: APIError)
    case serverErrorCode(code: Int, message: String?)

    public var description: String {
        switch self {
        case .invalidURL:
            "Error: The URL provided is invalid."
        case .invalidContentType:
            "Error: Content type is invalid."
        case .networkFailure(let underlyingError):
            "Error: Network failure occurred - \(underlyingError.localizedDescription)"
        case .parameterEncodingFailure:
            "Error: Failed to encode parameters."
        case .requestStringEncodingFailure:
            "Error: Failed to encode the data to string."
        case .requestJSONDecodingFailure:
            "Error: Failed to decode the data to JSON."
        case .requestDecodableDecodingFailure:
            "Error: Failed to decode the data to decodable."
        case .jsonSerializationFailure:
            "Error: Expected a serializable dictionary but got something else."
        case .urlEncodingFailure:
            "Error: Failed to encode parameters to url encoded data."
        case .invalidQueryValue(key: let key, value: let value):
            "Error: Invalid parameter - \(key): \(value)"
        case .unauthorized:
            "Unauthorized: Access token is invalid or expired"
        case .serverError(let apiError):
            apiError.description
        case .serverErrorCode(let code, let message):
            "Server Error (\(code)): \(message ?? "No message")"
        }
    }
}
