import Foundation

public enum TDDataError: Error, Equatable {
    case noSuchEntity(key: String)
    case createEntityFailure
    case convertDTOFailure
    case fetchEntityFaliure
    case updateEntityFailure
    case deleteEntityFailure
    case findEntityFailure
    case generalFailure
    case setUserDefaultFailure
}

extension TDDataError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .noSuchEntity(key):
            "\(key)에 대한 Entity가 존재하지 않습니다"
        case .createEntityFailure:
            "Entity 생성 실패"
        case .convertDTOFailure:
            "Entity에 대한 DTO 변환 실패"
        case .fetchEntityFaliure:
            "Entity 가져오기 실패"
        case .updateEntityFailure:
            "Entity 업데이트 실패"
        case .deleteEntityFailure:
            "Entity 삭제 실패"
        case .findEntityFailure:
            "Entity 찾기 실패"
        case .generalFailure:
            "알 수 없는 에러입니다."
        case .setUserDefaultFailure:
            "UserDefault 설정 실패"
        }
    }
}
