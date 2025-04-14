public struct FocusListResponseDTO: Decodable {
    public let concentrationDtos: [FocusDTO]
}

public struct FocusDTO: Decodable {
    let id: Int
    let date: String
    let targetCount: Int
    let settingCount: Int
    let time: Int
    let percentage: Int
    
    enum CodingKeys: String, CodingKey {
        case id, date, targetCount, settingCount, time, percentage
    }
}
