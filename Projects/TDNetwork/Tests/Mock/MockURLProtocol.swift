import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockResponseHandler: ((URLRequest) -> Result<(HTTPURLResponse, Data), Error>)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = self.client else { return }
        
        if let handler = MockURLProtocol.mockResponseHandler {
            switch handler(request) {
            case .success(let (response, data)):
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client.urlProtocol(self, didLoad: data)
            case .failure(let error):
                client.urlProtocol(self, didFailWithError: error)
            }
        } else {
            let error = NSError(domain: "MockURLProtocol", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock response handler not set."])
            client.urlProtocol(self, didFailWithError: error)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
