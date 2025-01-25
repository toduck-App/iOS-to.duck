import TDCore
import TDDomain

public final class RoutineRepositoryImpl: RoutineRepository {
    public init() { }
    
    public func fetchRoutine() async -> Result<Routine, TDDataError> {
        return .success(
            Routine(
                id: nil,
                title: "",
                category: TDCategory(colorHex: "", imageName: ""),
                isAllDay: false,
                isPublic: false,
                date: nil,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                memo: nil,
                recommendedRoutines: nil,
                isFinish: false
            )
        )
    }
    
    public func fetchRoutineList() async -> Result<[Routine], TDDataError> {
        .success([])
    }
    
    public func updateRoutine(routineId: Int) async -> Result<Void, TDDataError> {
        .success(())
    }
    
    public func deleteRoutine(routineId: Int) async -> Result<Void, TDDataError> {
        .success(())
    }
    
    public func createRoutine(routine: Routine) async -> Result<Void, TDDataError> {
        .success(())
    }
}
