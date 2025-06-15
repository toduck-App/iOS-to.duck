import XCTest
@testable import TDCore
@testable import TDDomain

final class FetchScheduleListUseCaseTests: XCTestCase {
    // 1) 하루 선택 + 반복 X
    func test하루선택_반복없음_하루만생성() async throws {
        // Arrange
        let schedule = Schedule(
            id: 1,
            title: "하루·반복X",
            category: TDCategory(colorHex: "#123456", imageName: "redBook"),
            startDate: "2025-04-10",
            endDate:   "2025-04-10",
            isAllDay: true,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
        let sut = FetchScheduleListUseCaseImpl(
            repository: MockScheduleRepository([schedule])
        )

        // Act
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate:   "2025-04-30"
        )

        // Assert
        let expectedDate = Date
            .convertFromString("2025-04-10", format: .yearMonthDay)!
            .stripTime()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[expectedDate]?.count, 1)
    }

    // 2) 하루 선택 + 반복 O
    func test하루선택_반복있음_요일마다생성() async throws {
        // Arrange
        let schedule = Schedule(
            id: 2,
            title: "하루·반복O [화·수]",
            category: TDCategory(colorHex: "#123456", imageName: "redBook"),
            startDate: "2025-04-05",          // 토요일
            endDate:   "2025-04-05",
            isAllDay: true,
            time: nil,
            repeatDays: [.tuesday, .wednesday],
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
        let sut = FetchScheduleListUseCaseImpl(
            repository: MockScheduleRepository([schedule])
        )

        // Act
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate:   "2025-04-30"
        )

        // Assert
        let formatter = DateFormatter.yyyymmdd
        let expectedStrings = [
            "2025-04-08","2025-04-09",
            "2025-04-15","2025-04-16",
            "2025-04-22","2025-04-23",
            "2025-04-29","2025-04-30"
        ]
        let expectedDates = Set(expectedStrings.compactMap { formatter.date(from:$0)?.stripTime() })

        XCTAssertEqual(result.keys.count, expectedDates.count)
        expectedDates.forEach { date in
            XCTAssertEqual(result[date]?.count, 1, "\(date) 가 누락되었습니다")
        }
    }

    // 3) 기간 선택 + 반복 X
    func test기간선택_반복없음_모든날짜생성() async throws {
        // Arrange
        let schedule = Schedule(
            id: 3,
            title: "기간·반복X",
            category: TDCategory(colorHex: "#123456", imageName: "redBook"),
            startDate: "2025-04-10",
            endDate:   "2025-04-12",
            isAllDay: true,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
        let sut = FetchScheduleListUseCaseImpl(
            repository: MockScheduleRepository([schedule])
        )

        // Act
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate:   "2025-04-30"
        )

        // Assert
        let formatter = DateFormatter.yyyymmdd
        let expected = ["2025-04-10","2025-04-11","2025-04-12"]
            .compactMap { formatter.date(from:$0)?.stripTime() }

        XCTAssertEqual(result.keys.count, expected.count)
        expected.forEach { date in
            XCTAssertEqual(result[date]?.count, 1)
        }
    }

    // 4) 기간 선택 + 반복 O
    func test기간선택_반복있음_특정요일만생성() async throws {
        // Arrange
        let schedule = Schedule(
            id: 4,
            title: "기간·반복O [월·수·금]",
            category: TDCategory(colorHex: "#123456", imageName: "redBook"),
            startDate: "2025-04-01",
            endDate:   "2025-04-30",
            isAllDay: true,
            time: nil,
            repeatDays: [.monday, .wednesday, .friday],
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
        let sut = FetchScheduleListUseCaseImpl(
            repository: MockScheduleRepository([schedule])
        )

        // Act
        let result = try await sut.execute(
            startDate: "2025-04-01",
            endDate:   "2025-04-30"
        )

        // Assert
        XCTAssertFalse(result.isEmpty)

        result.keys.forEach { date in
            let weekday = date.weekdayEnum()
            XCTAssertTrue([.monday,.wednesday,.friday].contains(weekday),
                          "허용되지 않은 요일 \(weekday) 발견")
        }
    }
    
    func test삭제된기록이있으면_해당날짜일정이생성되지않음() async throws {
        // Arrange
        let formatter = DateFormatter.yyyymmdd
        let targetDate = formatter.date(from: "2025-06-14")!

        let deletedRecord = ScheduleRecord(
            id: 999,
            isComplete: false,
            recordDate: "2025-06-14",
            deletedAt: "2025-06-14T13:50:59" // 삭제된 기록
        )

        let schedule = Schedule(
            id: 5,
            title: "삭제된 일정",
            category: TDCategory(colorHex: "#123456", imageName: "sleep"),
            startDate: "2025-06-14",
            endDate:   "2025-06-14",
            isAllDay: true,
            time: nil,
            repeatDays: [.saturday],
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: [deletedRecord]
        )

        let sut = FetchScheduleListUseCaseImpl(
            repository: MockScheduleRepository([schedule])
        )

        // Act
        let result = try await sut.execute(
            startDate: "2025-06-01",
            endDate:   "2025-06-30"
        )

        // Assert
        let stripped = targetDate.stripTime()
        XCTAssertNil(result[stripped], "삭제된 일정이 표시되었습니다")
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
