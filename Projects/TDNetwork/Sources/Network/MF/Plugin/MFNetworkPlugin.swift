import Foundation

public protocol MFNetworkPlugin: Sendable {
    /// 요청 전 호출
    func willSend(request: URLRequest, id: UUID)

    /// 응답 성공 시 호출
    func didReceive(response: URLResponse, data: Data, for request: URLRequest, id: UUID)

    /// 응답 실패 시 호출 (디코딩 실패 포함)
    func didFail(error: Error, request: URLRequest?, response: URLResponse?, data: Data?, id: UUID)
}

public extension MFNetworkPlugin {
    func willSend(request: URLRequest, id: UUID) {}
    func didReceive(response: URLResponse, data: Data, for request: URLRequest, id: UUID) {}
    func didFail(error: Error, request: URLRequest?, response: URLResponse?, data: Data?, id: UUID) {}
}
