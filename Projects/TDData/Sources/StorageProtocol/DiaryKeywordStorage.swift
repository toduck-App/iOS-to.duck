import TDCore
import TDDomain

public protocol DiaryKeywordStorage {
    func fetchDiaryKeyword() -> [DiaryKeywordDTO]
    func saveDiaryKeyword(_ keyword: DiaryKeywordDTO) -> Result<Void, TDCore.TDDataError>
    func deleteDiaryKeyword(_ keyword: [DiaryKeywordDTO]) -> Result<Void, TDCore.TDDataError>
}
