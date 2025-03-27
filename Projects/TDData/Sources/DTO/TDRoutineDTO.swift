public struct TDRoutineDTO: Codable {
    let routineId: Int
    let category: String
    let color: String
    let title: String
    let time: String
    let isPublic: Bool
    let isInDeletedState: Bool
    let daysOfWeek: [String]
    let memo: String?
}
