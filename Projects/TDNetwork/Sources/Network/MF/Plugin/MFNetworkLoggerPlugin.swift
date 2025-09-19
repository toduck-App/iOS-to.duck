import Foundation
import TDCore

public struct MFNetworkLoggerPlugin: MFNetworkPlugin {
    public init() {}

    // MARK: - Timing storage

    private static var startTimes: [UUID: UInt64] = [:]
    private static let lock = NSLock()

    // MARK: - MFNetworkPlugin

    public func willSend(request: URLRequest, id: UUID) {
        #if DEBUG
        MFNetworkLoggerPlugin.lock.lock()
        MFNetworkLoggerPlugin.startTimes[id] = DispatchTime.now().uptimeNanoseconds
        MFNetworkLoggerPlugin.lock.unlock()

        TDLogger.network(
            makeBlock(kind: .request,
                      url: request.url,
                      headers: request.allHTTPHeaderFields,
                      body: request.httpBody,
                      id: id,
                      showHeaders: true,
                      elapsedMS: nil)
        )
        #endif
    }

    public func didReceive(response: URLResponse, data: Data, for request: URLRequest, id: UUID) {
        #if DEBUG
        let elapsed = elapsedMS(for: id)

        TDLogger.network(
            makeBlock(kind: .response,
                      url: request.url,
                      headers: nil,
                      body: data,
                      id: id,
                      showHeaders: false,
                      elapsedMS: elapsed)
        )
        #endif
    }

    public func didFail(error: Error, request: URLRequest?, response: URLResponse?, data: Data?, id: UUID) {
        #if DEBUG
        let url = request?.url ?? (response as? HTTPURLResponse)?.url
        let elapsed = elapsedMS(for: id)

        TDLogger.network(
            makeBlock(kind: .failure,
                      url: url,
                      headers: request?.allHTTPHeaderFields,
                      body: data,
                      id: id,
                      showHeaders: true,
                      elapsedMS: elapsed)
        )
        #endif
    }

    // MARK: - Formatting

    private enum Kind {
        case request, response, failure

        var title: String {
            switch self {
            case .request: "[➡️ REQUEST]"
            case .response: "[⬅️ RESPONSE]"
            case .failure: "[❌ FAILURE]"
            }
        }
    }

    private func makeBlock(kind: Kind,
                           url: URL?,
                           headers: [AnyHashable: Any]?,
                           body: Data?,
                           id: UUID,
                           showHeaders: Bool,
                           elapsedMS: Int?) -> String
    {
        let headersBlock: String = {
            guard showHeaders else { return "\n" }
            return """

            [🧾 Headers]
            \(prettyHeaders(headers))

            """
        }()

        let timeBlock: String = {
            guard let ms = elapsedMS else { return "" }
            return """

            [⏱ Elapsed]
            \(ms) ms
            """
        }()

        return """

        \(kind.title)

        [NETWORK ID]
        \(id.uuidString)

        [URL]
        \(url?.absoluteString ?? "(nil)")\(headersBlock)\(timeBlock)

        [📥 Body]
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
           let str = String(data: data, encoding: .utf8)
        {
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
           let s = String(data: pretty, encoding: .utf8)
        {
            return s
        }

        if let s = String(data: data, encoding: .utf8) {
            return s
        }

        return "\(data.count) bytes (binary)"
    }

    // MARK: - Timing helper

    private func elapsedMS(for id: UUID) -> Int? {
        MFNetworkLoggerPlugin.lock.lock()
        defer { MFNetworkLoggerPlugin.lock.unlock() }

        guard let start = MFNetworkLoggerPlugin.startTimes.removeValue(forKey: id) else { return nil }
        let end = DispatchTime.now().uptimeNanoseconds
        let diffNS = end &- start
        return Int(Double(diffNS) / 1_000_000.0)
    }
}
