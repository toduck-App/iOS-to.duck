import XCTest
import TDDomain

final class FetchScheduleListUseCaseTests: XCTestCase {
    
    func test_하루선택_반복없는일정_포함된다() async throws {
        // Arrange
        let mockRepository = MockScheduleRepository()
        mockRepository.mockScheduleList = [
            makeSchedule(id: 1, title: "하루 반복X", start: "2025-04-06", end: "2025-04-06")
        ]
        let sut = FetchScheduleListUseCaseImpl(repository: mockRepository)

        // Act
        let result = try await sut.execute(startDate: "2025-04-06", endDate: "2025-04-06")

        // Assert
        XCTAssertEqual(result.map { $0.id }, [1])
    }

    func test_하루선택_반복있는일정_요일맞으면_포함된다() async throws {
        // Arrange
        let mockRepository = MockScheduleRepository()
        mockRepository.mockScheduleList = [
            makeSchedule(id: 2, title: "하루 반복O", start: "2025-04-01", end: "2025-04-01", repeatDays: [.sunday])
        ]
        let sut = FetchScheduleListUseCaseImpl(repository: mockRepository)

        // Act
        let result = try await sut.execute(startDate: "2025-04-06", endDate: "2025-04-06") // 일요일

        // Assert
        XCTAssertEqual(result.map { $0.id }, [2])
    }

    func test_기간선택_반복없는일정_기간내포함시_포함된다() async throws {
        // Arrange
        let mockRepository = MockScheduleRepository()
        mockRepository.mockScheduleList = [
            makeSchedule(id: 3, title: "기간 반복X", start: "2025-04-01", end: "2025-04-10")
        ]
        let sut = FetchScheduleListUseCaseImpl(repository: mockRepository)

        // Act
        let result = try await sut.execute(startDate: "2025-04-06", endDate: "2025-04-06")

        // Assert
        XCTAssertEqual(result.map { $0.id }, [3])
    }

    func test_기간선택_반복있는일정_기간내_요일맞으면_포함된다() async throws {
        // Arrange
        let mockRepository = MockScheduleRepository()
        mockRepository.mockScheduleList = [
            makeSchedule(id: 4, title: "기간 반복O", start: "2025-04-01", end: "2025-04-30", repeatDays: [.sunday])
        ]
        let sut = FetchScheduleListUseCaseImpl(repository: mockRepository)

        // Act
        let result = try await sut.execute(startDate: "2025-04-06", endDate: "2025-04-06") // 일요일

        // Assert
        XCTAssertEqual(result.map { $0.id }, [4])
    }
    
    private func makeSchedule(
        id: Int,
        title: String,
        start: String,
        end: String,
        repeatDays: [TDWeekDay]? = nil
    ) -> Schedule {
        return Schedule(
            id: id,
            title: title,
            category: TDCategory(colorHex: "#FFFFFF", imageName: "computer"),
            startDate: start,
            endDate: end,
            isAllDay: true,
            time: nil,
            repeatDays: repeatDays,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil
        )
    }
}
