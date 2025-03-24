import Foundation

public actor JWTDecoder {

    public static let shared = JWTDecoder()
    private init() {}

    /// JWT 토큰을 디코딩해서 Payload를 Dictionary로 반환
    public func decode(token jwt: String) -> [String: Any]? {
        let segments = jwt.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }

        var base64String = segments[1]

        let requiredLength = 4 * ((base64String.count + 3) / 4)
        let paddingLength = requiredLength - base64String.count
        base64String += String(repeating: "=", count: paddingLength)

        guard let data = Data(base64Encoded: base64String) else { return nil }

        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json as? [String: Any]
    }
}
