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
                TDCategoryDTO(colorHex: "#F0F0F0", imageName: "computer"),
                TDCategoryDTO(colorHex: "#F7F7FF", imageName: "food"),
                TDCategoryDTO(colorHex: "#FFF4EB", imageName: "pencil"),
                TDCategoryDTO(colorHex: "#FFEFF3", imageName: "redBook"),
                TDCategoryDTO(colorHex: "#F2F8FE", imageName: "sleep"),
                TDCategoryDTO(colorHex: "#FAF5EF", imageName: "power"),
                TDCategoryDTO(colorHex: "#F4F6FA", imageName: "people"),
                TDCategoryDTO(colorHex: "#F9F2F2", imageName: "medicine"),
                TDCategoryDTO(colorHex: "#F4F8F7", imageName: "talk"),
                TDCategoryDTO(colorHex: "#FFF4EB", imageName: "heart"),
                TDCategoryDTO(colorHex: "#F9FBE5", imageName: "vehicle"),
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
