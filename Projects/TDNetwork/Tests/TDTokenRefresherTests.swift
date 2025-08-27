import Foundation
import XCTest
@testable import TDCore
@testable import TDNetwork

// Mock Models
struct Schedule: Codable, Equatable { let eventName: String }
struct Routine: Codable, Equatable { let routineName: String }
struct ServerResponse<T: Codable>: Codable { let code: Int; let message: String; let content: T? }
struct LoginUserResponseBody: Codable { let accessToken: String; let userId: Int; let refreshToken: String; let refreshTokenExpiredAt: String }

actor CallCounter {
    private(set) var count = 0
    func increment() { count += 1 }
    func reset() { count = 0 }
}

final class TokenConcurrencyTests: XCTestCase {
    var session: MFSession!
    let refreshTokenCallCounter = CallCounter()
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        let mockSession = MFSession(session: urlSession)
        self.session = mockSession
        MFSession.default = mockSession
        TDKeyChainManager.shared = MockKeyChainManager()
        
        TDTokenManager.shared.setTokensForTesting(
            accessToken: "expired-access-token",
            refreshToken: "valid-refresh-token"
        )
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.mockResponseHandler = nil
        session = nil
        TDTokenManager.shared.setTokensForTesting(accessToken: nil, refreshToken: nil)
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    func test_토큰만료시_일정과_루틴을_동시에_요청해도_갱신은_한번만_호출된다() async throws {
        // Arrange 준비 단계: 테스트 대상 시스템(SUT)와 의존성을 원하는 상태로 만들기
        
        let expiredTokenErrorResponse = ServerResponse<String>(code: 40104, message: "Expired Token", content: nil)
        let expiredTokenData = try JSONEncoder().encode(expiredTokenErrorResponse)
        
        let newTokens = LoginUserResponseBody(accessToken: "new-access-token", userId: 123, refreshToken: "new-refresh-token", refreshTokenExpiredAt: "")
        let tokenRefreshSuccessResponse = ServerResponse(code: 20000, message: "Success", content: newTokens)
        let tokenRefreshSuccessData = try JSONEncoder().encode(tokenRefreshSuccessResponse)
        
        let scheduleSuccessResponse = ServerResponse(code: 20000, message: "Success", content: Schedule(eventName: "팀 회의"))
        let scheduleSuccessData = try JSONEncoder().encode(scheduleSuccessResponse)
        let routineSuccessResponse = ServerResponse(code: 20000, message: "Success", content: Routine(routineName: "아침 운동"))
        let routineSuccessData = try JSONEncoder().encode(routineSuccessResponse)
        
        let scheduleURL = URL(string: "https://api.example.com/schedule")!
        let routineURL = URL(string: "https://api.example.com/routine")!
        let refreshURL = URL(string: "http://localhost:8080/v1/auth/refresh")!
        
        MockURLProtocol.mockResponseHandler = { request in
            let url = request.url!
            let headers = request.allHTTPHeaderFields ?? [:]
            let token = headers["Authorization"]?.replacingOccurrences(of: "Bearer ", with: "")
            
            if url == refreshURL {
                Task { await self.refreshTokenCallCounter.increment() }
                
                let futureDate = Date().addingTimeInterval(3600)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                let expiryString = dateFormatter.string(from: futureDate)
                
                let httpResponse = HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Set-Cookie": "refreshToken=new-refresh-token; Expires=\(expiryString)"]
                )!
                return .success((httpResponse, tokenRefreshSuccessData))
            }
            
            if token == "expired-access-token" {
                let httpResponse = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
                return .success((httpResponse, expiredTokenData))
            }
            
            if token == "new-access-token" {
                let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                if url == scheduleURL {
                    return .success((httpResponse, scheduleSuccessData))
                } else if url == routineURL {
                    return .success((httpResponse, routineSuccessData))
                }
            }
            
            XCTFail("처리되지 않은 Mock 요청이 발생했습니다: \(request.httpMethod ?? "") \(url)")
            let error = NSError(domain: "MockURLProtocol", code: -1, userInfo: nil)
            return .failure(error)
        }
        
        // Act 실행 단계: SUT 메소드를 호출하면서 의존성을 전달해서 결과를 저장하기
        
        let (scheduleResult, routineResult) = try await withThrowingTaskGroup(of: Any.self, returning: (Schedule?, Routine?).self) { group in
            
            group.addTask {
                let request = MFRequest(url: scheduleURL).get().addHeaders([.authorization(bearerToken: "expired-access-token")])
                let response = try await self.session.requestDecodable(of: Schedule.self, request)
                return response.value
            }
            
            group.addTask {
                let request = MFRequest(url: routineURL).get().addHeaders([.authorization(bearerToken: "expired-access-token")])
                let response = try await self.session.requestDecodable(of: Routine.self, request)
                return response.value
            }
            
            var finalSchedule: Schedule?
            var finalRoutine: Routine?
            
            for try await result in group {
                if let schedule = result as? Schedule { finalSchedule = schedule }
                if let routine = result as? Routine { finalRoutine = routine }
            }
            
            return (finalSchedule, finalRoutine)
        }
        
        // Assert 검증 단계: 결과와 기대치를 비교해서 검증하기
        
        XCTAssertEqual(scheduleResult?.eventName, "팀 회의")
        XCTAssertEqual(routineResult?.routineName, "아침 운동")
        
        let refreshCallCount = await refreshTokenCallCounter.count
        XCTAssertEqual(refreshCallCount, 1, "토큰 갱신 API는 단 한 번만 호출되어야 합니다.")
        
        XCTAssertEqual(TDTokenManager.shared.accessToken, "new-access-token")
    }
}
