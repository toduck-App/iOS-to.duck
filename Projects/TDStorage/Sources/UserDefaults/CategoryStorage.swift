import TDData
import Foundation

final class CategoryStorageImpl: CategoryStorage {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func fetchCategoryColors() async throws -> [String] {
        return ["#123456", "#345676", "#FF5733", "#33FF57"]
    }
    
    func updateCategoryColors(colors: [String]) async throws {
        
    }
}
