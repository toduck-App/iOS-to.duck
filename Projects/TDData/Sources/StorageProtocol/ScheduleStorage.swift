import Foundation
import EventKit

/// 캘린더 데이터 소스(Storage)가 수행해야 하는 기능을 정의하는 프로토콜입니다.
/// EventKit 프레임워크에 직접 접근하여 원시 데이터인 `EKEvent`를 가져오는 역할을 합니다.
public protocol ScheduleStorage {
    
    /// 지정된 기간에 해당하는 모든 캘린더 이벤트를 가져옵니다.
    /// - Parameters:
    ///   - startDate: 조회를 시작할 날짜
    ///   - endDate: 조회를 종료할 날짜
    /// - Returns: EventKit의 원시 데이터 모델인 `EKEvent`의 배열
    /// - Throws: 권한이 없거나 데이터를 가져오는 중 오류가 발생하면 에러를 던집니다.
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [EKEvent]
}
