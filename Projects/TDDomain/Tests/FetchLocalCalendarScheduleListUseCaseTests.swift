import XCTest
@testable import TDCore
@testable import TDDomain

final class FetchLocalCalendarScheduleListUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: FetchLocalCalendarScheduleListUseCase!
    var mockRepository: MockScheduleRepository!
    
    // MARK: - Test Lifecycle
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockScheduleRepository()
        sut = FetchLocalCalendarScheduleListUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Success Case Test
    
    func test_로컬일정목록을_날짜별로_정확히_그룹화하는지() async throws {
        // GIVEN: Repository가 반환할 테스트용 데이터를 준비합니다.
        // 단일 일정과 기간 일정을 모두 포함하여 그룹화 로직을 검증합니다.
        mockRepository.mockScheduleList = [
            // 1. 단일 일정 (2025-08-21)
            Schedule(id: 101, title: "치과 예약", startDate: "2025-08-21", endDate: "2025-08-21"),
            // 2. 기간 일정 (2025-08-20 ~ 2025-08-22)
            Schedule(id: 102, title: "여름 휴가", startDate: "2025-08-20", endDate: "2025-08-22")
        ]
        
        // WHEN: UseCase를 실행하여 결과를 받습니다.
        let result = try await sut.execute(startDate: "2025-08-01", endDate: "2025-08-31")
        
        // THEN: 결과가 기대한 대로 그룹화되었는지 검증합니다.
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 1. 결과 딕셔너리의 키 개수 검증 (20일, 21일, 22일 -> 총 3일)
        XCTAssertEqual(result.count, 3, "총 3개의 날짜에 대한 일정이 있어야 합니다.")
        
        // 2. 8월 20일에는 '여름 휴가' 하나만 있어야 합니다.
        let day20Key = calendar.startOfDay(for: dateFormatter.date(from: "2025-08-20")!)
        XCTAssertNotNil(result[day20Key], "8월 20일 일정이 존재해야 합니다.")
        XCTAssertEqual(result[day20Key]?.count, 1, "8월 20일에는 1개의 일정이 있어야 합니다.")
        XCTAssertEqual(result[day20Key]?.first?.title, "여름 휴가")
        
        // 3. 8월 21일에는 '치과 예약'과 '여름 휴가' 두 개가 모두 있어야 합니다.
        let day21Key = calendar.startOfDay(for: dateFormatter.date(from: "2025-08-21")!)
        XCTAssertNotNil(result[day21Key], "8월 21일 일정이 존재해야 합니다.")
        XCTAssertEqual(result[day21Key]?.count, 2, "8월 21일에는 2개의 일정이 있어야 합니다.")
        
        // 4. 8월 23일에는 일정이 없어야 합니다 (결과에 포함되지 않아야 함).
        let day23Key = calendar.startOfDay(for: dateFormatter.date(from: "2025-08-23")!)
        XCTAssertNil(result[day23Key], "8월 23일에는 일정이 없어야 합니다.")
    }
    
    // MARK: - Failure Case Test
    
    func test_리포지토리에서_에러가발생하면_UseCase가_에러를전달하는지() async {
        // GIVEN: Repository가 에러를 던지도록 설정합니다.
        mockRepository.shouldThrowError = true
        
        // WHEN & THEN: UseCase 실행 시 에러가 발생하는지 검증합니다.
        do {
            _ = try await sut.execute(startDate: "2025-08-01", endDate: "2025-08-31")
            
            // 만약 이 라인까지 코드가 실행된다면, 에러가 발생하지 않았다는 의미이므로 테스트를 실패시킵니다.
            XCTFail("UseCase가 에러를 던져야 했지만, 정상적으로 완료되었습니다.")
            
        } catch {
            // 에러가 성공적으로 잡혔습니다. 이제 잡힌 에러가 우리가 예상한 에러인지 확인합니다.
            XCTAssertEqual(error as? TestError, TestError.repositoryError, "예상치 못한 다른 종류의 에러가 발생했습니다.")
        }
    }
}
