import Foundation

public struct ScheduleResponseDTO: Decodable {
    public let id: Int
    public let title: String
    public let category: String
    public let color: String
    public let startDate: String
    public let endDate: String
    public let isAllDay: Bool
    public let time: String?
    public let alarm: String?
    public let daysOfWeek: [String]?
    public let location: String?
    public let memo: String?
    public let isFinished: Bool
}
