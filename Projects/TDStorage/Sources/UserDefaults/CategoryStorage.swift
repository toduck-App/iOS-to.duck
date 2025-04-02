import Foundation
import TDCore
import TDData

final class CategoryStorageImpl: CategoryStorage {
    private let userDefaults: UserDefaults
    private let key = "categoryColors"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func fetchCategories() async throws -> [TDCategoryDTO] {
        guard let data = userDefaults.data(forKey: key) else {
            // 기본값을 반환
            return [
                TDCategoryDTO(colorHex: "#DADADA", imageName: "computer"),
                TDCategoryDTO(colorHex: "#EAECFF", imageName: "food"),
                TDCategoryDTO(colorHex: "#FFE3CC", imageName: "pencil"),
                TDCategoryDTO(colorHex: "#FFD6E2", imageName: "redBook"),
                TDCategoryDTO(colorHex: "#DEEEFC", imageName: "sleep"),
                TDCategoryDTO(colorHex: "#F3E6D6", imageName: "power"),
                TDCategoryDTO(colorHex: "#E4E9F3", imageName: "people"),
                TDCategoryDTO(colorHex: "#F0DFDF", imageName: "medicine"),
                TDCategoryDTO(colorHex: "#E3EEEA", imageName: "talk"),
                TDCategoryDTO(colorHex: "#FFE3CC", imageName: "heart"),
                TDCategoryDTO(colorHex: "#F0F4BF", imageName: "vehicle"),
            ]
        }
        let decoder = JSONDecoder()
        return try decoder.decode([TDCategoryDTO].self, from: data)
    }

    func updateCategories(categories: [TDCategoryDTO]) async throws -> Result<Void, TDDataError> {
        let encoder = JSONEncoder()
        let data = try encoder.encode(categories)
        userDefaults.set(data, forKey: key)
        
        return .success(())
    }
}
