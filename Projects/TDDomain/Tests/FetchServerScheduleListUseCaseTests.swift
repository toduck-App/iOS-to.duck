import XCTest
@testable import TDCore
@testable import TDDomain

final class FetchServerScheduleListUseCaseTests: XCTestCase {
    // MARK: - Properties
    
    var sut: FetchServerScheduleListUseCase!
    var mockRepository: MockScheduleRepository!
    
    // MARK: - Test Lifecycle
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockScheduleRepository()
        sut = FetchServerScheduleListUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test Cases
    
    // 1) 하루 선택 + 반복 X
    func test하루선택_반복없음_하루만생성() async throws {
        // GIVEN
        let schedule = Schedule(id: 1, title: "하루·반복X", startDate: "2025-04-10", endDate: "2025-04-10")
        mockRepository.mockScheduleList = [schedule]
        
        // WHEN
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate: "2025-04-30"
        )
        
        // THEN
        let expectedDate = Date.convertFromString("2025-04-10", format: .yearMonthDay)!.stripTime()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[expectedDate]?.count, 1)
    }
    
    // 2) 하루 선택 + 반복 O
    func test하루선택_반복있음_요일마다생성() async throws {
        // GIVEN
        let schedule = Schedule(id: 2, title: "하루·반복O [화·수]", startDate: "2025-04-05", endDate: "2025-04-05", repeatDays: [.tuesday, .wednesday])
        mockRepository.mockScheduleList = [schedule]
        
        // WHEN
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate: "2025-04-30"
        )
        
        // THEN
        let expectedStrings = [
            "2025-04-08", "2025-04-09",
            "2025-04-15", "2025-04-16",
            "2025-04-22", "2025-04-23",
            "2025-04-29", "2025-04-30"
        ]
        let expectedDates = Set(expectedStrings.compactMap { DateFormatter.yyyymmdd.date(from:$0)?.stripTime() })
        
        XCTAssertEqual(result.keys.count, expectedDates.count)
        expectedDates.forEach { date in
            XCTAssertEqual(result[date]?.count, 1, "\(date) 가 누락되었습니다")
        }
    }
    
    // 3) 기간 선택 + 반복 X
    func test기간선택_반복없음_모든날짜생성() async throws {
        // GIVEN
        let schedule = Schedule(id: 3, title: "기간·반복X", startDate: "2025-04-10", endDate: "2025-04-12")
        mockRepository.mockScheduleList = [schedule]
        
        // WHEN
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate: "2025-04-30"
        )
        
        // THEN
        let expected = ["2025-04-10", "2025-04-11", "2025-04-12"]
            .compactMap { DateFormatter.yyyymmdd.date(from:$0)?.stripTime() }
        
        XCTAssertEqual(result.keys.count, expected.count)
        expected.forEach { date in
            XCTAssertEqual(result[date]?.count, 1)
        }
    }
    
    // 4) 기간 선택 + 반복 O
    func test기간선택_반복있음_특정요일만생성() async throws {
        // GIVEN
        let schedule = Schedule(id: 4, title: "기간·반복O [월·수·금]", startDate: "2025-04-01", endDate: "2025-04-30", repeatDays: [.monday, .wednesday, .friday])
        mockRepository.mockScheduleList = [schedule]
        
        // WHEN
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate: "2025-04-30"
        )
        
        // THEN
        XCTAssertFalse(result.isEmpty)
        
        result.keys.forEach { date in
            let weekday = date.weekdayEnum()
            XCTAssertTrue([.monday, .wednesday, .friday].contains(weekday),
                          "허용되지 않은 요일 \(weekday) 발견")
        }
    }
    
    func test삭제된기록이있으면_해당날짜일정이생성되지않음() async throws {
        // GIVEN
        let deletedRecord = ScheduleRecord(recordDate: "2025-06-14", deletedAt: "2025-06-14T13:50:59")
        let schedule = Schedule(id: 5, title: "삭제된 일정", startDate: "2025-06-14", endDate: "2025-06-14", repeatDays: [.saturday], scheduleRecords: [deletedRecord])
        mockRepository.mockScheduleList = [schedule]
        
        // WHEN
        let result = try await sut.execute(
            startDate: "2025-06-01",
            endDate: "2025-06-30"
        )
        
        // THEN
        let targetDate = DateFormatter.yyyymmdd.date(from: "2025-06-14")!
        XCTAssertNil(result[targetDate.stripTime()], "삭제된 일정이 표시되었습니다")
    }
    
    func test기간일정에서_삭제된날짜는제외된다() async throws {
        // GIVEN
        let deletedRecord = ScheduleRecord(recordDate: "2025-06-16", deletedAt: "2025-06-16T10:00:00")
        let schedule = Schedule(id: 6, title: "기간 일정 중 일부 삭제", startDate: "2025-06-12", endDate: "2025-06-17", scheduleRecords: [deletedRecord])
        mockRepository.mockScheduleList = [schedule]
        
        // WHEN
        let result = try await sut.execute(
            startDate: "2025-06-01",
            endDate: "2025-06-30"
        )
        
        // THEN
        let expectedDates = [
            "2025-06-12", "2025-06-13", "2025-06-14", "2025-06-15", "2025-06-17"
        ].compactMap { DateFormatter.yyyymmdd.date(from: $0)?.stripTime() }
        
        let excludedDate = DateFormatter.yyyymmdd.date(from: "2025-06-16")!.stripTime()
        
        XCTAssertEqual(result.keys.count, expectedDates.count, "삭제된 날짜를 제외한 나머지 날짜 수가 일치하지 않습니다.")
        XCTAssertNil(result[excludedDate], "삭제된 2025-06-16 일정이 표시됨")
    }
}

// MARK: - Test Helpers

private extension DateFormatter {
    static let yyyymmdd: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale   = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

private extension Date {
    /// 00:00:00 로 통일하여 dictionary key 비교 시 시간 차이를 제거
    func stripTime() -> Date { Calendar.current.startOfDay(for: self) }
}
