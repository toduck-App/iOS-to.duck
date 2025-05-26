import Foundation

public struct Focus: Hashable {
    public let id: Int
    public let date: Date
    public let targetCount: Int
    public let settingCount: Int
    public let time: Int
    public let percentage: Int
    
    public init(
        id: Int,
        date: Date,
        targetCount: Int,
        settingCount: Int,
        time: Int,
        percentage: Int
    ) {
        self.id = id
        self.date = date
        self.targetCount = targetCount
        self.settingCount = settingCount
        self.time = time
        self.percentage = percentage
    }
}
