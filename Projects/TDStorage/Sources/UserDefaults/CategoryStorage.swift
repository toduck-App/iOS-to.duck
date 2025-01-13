import Foundation
import TDData

final class CategoryStorageImpl: CategoryStorage {
    private let userDefaults: UserDefaults
    private let key = "categoryColors"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func fetchCategoryColors() async throws -> [TDCategoryDTO] {
        guard let data = userDefaults.data(forKey: key) else {
            // 기본값을 반환
            return [
                TDCategoryDTO(colorHex: "#FFD6E2", imageName: "computer"),
                TDCategoryDTO(colorHex: "#FFE3CC", imageName: "rice"),
                TDCategoryDTO(colorHex: "#FFF7D9", imageName: "pencil"),
                TDCategoryDTO(colorHex: "#DAF9DD", imageName: "redBook"),
                TDCategoryDTO(colorHex: "#DEEEFC", imageName: "yellowBook"),
                TDCategoryDTO(colorHex: "#EAECFF", imageName: "sleep"),
                TDCategoryDTO(colorHex: "#F3E6D6", imageName: "power"),
                TDCategoryDTO(colorHex: "#F9D6CF", imageName: "people"),
                TDCategoryDTO(colorHex: "#F3D9FF", imageName: "medicine"),
                TDCategoryDTO(colorHex: "#D6D6D6", imageName: "talk"),
                TDCategoryDTO(colorHex: "#FFD6E2", imageName: "heart"),
                TDCategoryDTO(colorHex: "#FFE3CC", imageName: "vehicle"),
                TDCategoryDTO(colorHex: "#FFFFFF", imageName: "none"),
            ]
        }
        let decoder = JSONDecoder()
        return try decoder.decode([TDCategoryDTO].self, from: data)
    }

    func updateCategoryColors(colors: [TDCategoryDTO]) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(colors)
        userDefaults.set(data, forKey: key)
    }
}
