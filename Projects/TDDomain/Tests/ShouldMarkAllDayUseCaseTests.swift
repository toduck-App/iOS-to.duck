import XCTest
import TDDomain
import TDCore

final class ShouldMarkAllDayUseCaseTests: XCTestCase {
    private var useCase: ShouldMarkAllDayUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        useCase = ShouldMarkAllDayUseCaseImpl()
    }

    override func tearDownWithError() throws {
        useCase = nil
        try super.tearDownWithError()
    }

    func test_모든일정이AllDay이고_3개이상일때_true() {
        // Arrange
        let schedules = createSchedules(count: 3, isAllDay: true)

        // Act
        let result = useCase.execute(with: schedules)

        // Assert
        XCTAssertTrue(result)
    }

    func test_모든일정이AllDay이지만_2개일때_false() {
        // Arrange
        let schedules = createSchedules(count: 2, isAllDay: true)

        // Act
        let result = useCase.execute(with: schedules)

        // Assert
        XCTAssertFalse(result)
    }

    func test_일정중하나라도AllDay가아닐때_false() {
        // Arrange
        var schedules = createSchedules(count: 3, isAllDay: true)
        schedules[1] = createSchedule(isAllDay: false)

        // Act
        let result = useCase.execute(with: schedules)

        // Assert
        XCTAssertFalse(result)
    }

    func test_일정이없을때_false() {
        // Arrange
        let schedules: [Schedule] = []

        // Act
        let result = useCase.execute(with: schedules)

        // Assert
        XCTAssertFalse(result)
    }

    // MARK: - Helper

    private func createSchedules(count: Int, isAllDay: Bool) -> [Schedule] {
        return (0..<count).map { _ in createSchedule(isAllDay: isAllDay) }
    }

    private func createSchedule(isAllDay: Bool) -> Schedule {
        return Schedule(
            id: 1,
            title: "Sample",
            category: TDCategory(colorHex: "#FFFFFF", imageName: "test"),
            startDate: "2025-04-04",
            endDate: "2025-04-04",
            isAllDay: isAllDay,
            time: nil,
            repeatDays: nil,
            alarmTime: nil,
            place: nil,
            memo: nil,
            isFinished: false,
            scheduleRecords: nil,
            source: .server
        )
    }
}
