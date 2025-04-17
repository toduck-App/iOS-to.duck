import Foundation
import TDCore
import TDDomain

public struct FocusListResponseDTO: Decodable {
    public let concentrationDtos: [FocusDTO]
    
    public func convertToFocusList() -> [Focus] {
        concentrationDtos.compactMap { $0.convertToFocus() }
    }
}

public struct FocusDTO: Decodable {
    public let id: Int
    public let date: String
    public let targetCount: Int
    public let settingCount: Int
    public let time: Int
    public let percentage: Int
    
    public func convertToFocus() -> Focus? {
        guard let date = Date.convertFromString(date, format: .yearMonthDay) else {
            return nil
        }
        
        return Focus(
            id: id,
            date: date,
            targetCount: targetCount,
            settingCount: settingCount,
            time: time,
            percentage: percentage
        )
    }
}
