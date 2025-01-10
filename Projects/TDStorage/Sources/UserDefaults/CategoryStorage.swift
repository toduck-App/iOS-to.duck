import TDData
import Foundation

final class CategoryStorageImpl: CategoryStorage {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func fetchCategoryColors() async throws -> [String] {
        userDefaults.stringArray(forKey: "categoryColors")
        ?? [
            "#FFD6E2",
            "#FFE3CC",
            "#FFF7D9",
            "#DAF9DD",
            "#DEEEFC",
            "#EAECFF",
            "#F3E6D6",
            "#F9D6CF",
            "#F3D9FF",
            "#D6D6D6",
            "#FFD6E2",
            "#FFE3CC"
        ]
    }
    
    func updateCategoryColors(colors: [String]) async throws {
        
    }
}
