import Foundation
import TDCore
import TDData
import TDDomain

public final class DiaryKeywordStorageImpl: DiaryKeywordStorage {
    private let userDefaults: UserDefaults
    private let key = "diaryKeywords"
    private let initializedKey = "diaryKeywordInitialized"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        initializeIfNeeded()
    }

    private func initializeIfNeeded() {
        guard userDefaults.bool(forKey: initializedKey) == false else { return }

        let defaultKeywords = DefaultDiaryKeywords.all
            .flatMap { $0.value }
            .map { DiaryKeywordDTO(id: $0.id, name: $0.name, category: $0.category.rawValue) }

        if let encoded = try? JSONEncoder().encode(defaultKeywords) {
            userDefaults.set(encoded, forKey: key)
        }

        userDefaults.set(true, forKey: initializedKey)
    }

    public func fetchDiaryKeyword() -> [DiaryKeywordDTO] {
        guard let data = userDefaults.data(forKey: key) else { return [] }

        return (try? JSONDecoder().decode([DiaryKeywordDTO].self, from: data)) ?? []
    }

    public func saveDiaryKeyword(_ keyword: DiaryKeywordDTO) -> Result<Void, TDDataError> {
        var current = fetchDiaryKeyword()

        if current.contains(keyword) {
            return .success(())
        }

        current.append(keyword)

        return save(current)
    }

    public func deleteDiaryKeyword(_ keywords: [DiaryKeywordDTO]) -> Result<Void, TDDataError> {
        var current = fetchDiaryKeyword()

        current.removeAll { keyword in
            keywords.contains(keyword)
        }

        return save(current)
    }

    private func save(_ keywords: [DiaryKeywordDTO]) -> Result<Void, TDDataError> {
        do {
            let encoded = try JSONEncoder().encode(keywords)
            userDefaults.set(encoded, forKey: key)
            return .success(())
        } catch {
            return .failure(.createEntityFailure)
        }
    }
}
