import TDDomain
import Foundation

public struct RoutineListForDatesResponseDTO: Decodable {
    let startDate: String?
    let endDate: String?
    let dateRoutines: [RoutineListDetail]
}
