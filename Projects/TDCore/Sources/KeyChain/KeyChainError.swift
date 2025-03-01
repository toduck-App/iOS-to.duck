import Foundation

enum KeyChainError: Error, CustomStringConvertible {
    case duplicateItem
    case itemNotFound
    case unexpectedStatus(OSStatus)
    case typeConversionError
    case invalidData
    
    var description: String {
        switch self {
        case .duplicateItem:
            return "이미 해당 키에 해당하는 데이터가 존재합니다."
        case .itemNotFound:
            return "해당 키에 해당하는 데이터가 존재하지 않습니다."
        case .unexpectedStatus(let status):
            return "예상치 못한 상태 코드: \(status)"
        case .typeConversionError:
            return "데이터 변환에 실패했습니다."
        case .invalidData:
            return "데이터가 유효하지 않습니다."
        }
    }
}
