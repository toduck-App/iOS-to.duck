import Foundation

public protocol FetchRoutineListForDatesUseCase {
    func execute(startDate: String, endDate: String) async throws -> [Date: [Routine]]
}

public final class FetchRoutineListForDatesUseCaseImpl: FetchRoutineListForDatesUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(startDate: String, endDate: String) async throws -> [Date: [Routine]] {
        let routinesByDates = try await repository.fetchRoutineListForDates(startDate: startDate, endDate: endDate)
        return convertStringDateDictToDateDict(with: routinesByDates)
    }
    
    public func convertStringDateDictToDateDict(with routineForDates: [String: [Routine]]) -> [Date: [Routine]] {
        var routineDateDict: [Date: [Routine]] = [:]
        
        for (dateString, routines) in routineForDates {
            if let date = Date.convertFromString(dateString, format: .yearMonthDay) {
                routineDateDict[date] = routines
            }
        }
        
        return routineDateDict
    }
}
