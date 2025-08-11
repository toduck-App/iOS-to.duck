import Foundation
import TDCore

public struct MFNetworkLoggerPlugin: MFNetworkPlugin {
    public init() {}

    // MARK: - MFNetworkPlugin

    public func willSend(request: URLRequest, id: UUID) {
        #if DEBUG
        TDLogger.network(
            makeBlock(kind: .request,
                      url: request.url,
                      headers: request.allHTTPHeaderFields,
                      body: request.httpBody,
                      id: id,
                      showHeaders: true)
        )
        #endif
    }

    public func didReceive(response: URLResponse, data: Data, for request: URLRequest, id: UUID) {
        #if DEBUG
        TDLogger.network(
            makeBlock(kind: .response,
                      url: request.url,
                      headers: nil, // 응답 헤더는 비표시
                      body: data,
                      id: id,
                      showHeaders: false)
        )
        #endif
    }

    public func didFail(error: Error, request: URLRequest?, response: URLResponse?, data: Data?, id: UUID) {
        #if DEBUG
        let url = request?.url ?? (response as? HTTPURLResponse)?.url
        TDLogger.network(
            makeBlock(kind: .failure,
                      url: url,
                      headers: request?.allHTTPHeaderFields, // 실패 시 요청 헤더 표시
                      body: data,
                      id: id,
                      showHeaders: true)
        )
        #endif
    }

    // MARK: - Formatting

    private enum Kind {
        case request, response, failure

        var title: String {
            switch self {
            case .request:  "[➡️ REQUEST]"
            case .response: "[⬅️ RESPONSE]"
            case .failure:  "[❌ FAILURE]"
            }
        }
    }

    private func makeBlock(kind: Kind,
                           url: URL?,
                           headers: [AnyHashable: Any]?,
                           body: Data?,
                           id: UUID,
                           showHeaders: Bool) -> String
    {
        let headersBlock: String = {
            guard showHeaders else { return "\n" }
            return """

            [🧾 Headers]
            \(prettyHeaders(headers))

            """
        }()

        return """
        
        \(kind.title)
        
        [NETWORK ID] 
        \(id.uuidString)

        [URL] 
        \(url?.absoluteString ?? "(nil)")\(headersBlock)
        
        [📤 Body]
        \(bodyPreview(body))
        
        """
    }

    // MARK: - Helpers

    private func prettyHeaders(_ headers: [AnyHashable: Any]?) -> String {
        guard let headers, !headers.isEmpty else { return "[empty]" }

        var redacted: [String: String] = [:]
        for (k, v) in headers {
            let key = String(describing: k)
            let value = String(describing: v)
            if isSensitiveHeader(key) {
                redacted[key] = "🔒 (redacted)"
            } else {
                redacted[key] = value
            }
        }

        if let data = try? JSONSerialization.data(withJSONObject: redacted, options: [.prettyPrinted]),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return redacted.description
    }

    private func isSensitiveHeader(_ name: String) -> Bool {
        let lower = name.lowercased()
        return lower == "authorization"
            || lower == "cookie"
            || lower == "set-cookie"
            || lower == "x-api-key"
    }

    private func bodyPreview(_ data: Data?) -> String {
        guard let data, !data.isEmpty else { return "[empty]" }

        if let obj = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted]),
           let s = String(data: pretty, encoding: .utf8) {
            return s
        }

        if let s = String(data: data, encoding: .utf8) {
            return s
        }

        return "\(data.count) bytes (binary)"
    }
}
