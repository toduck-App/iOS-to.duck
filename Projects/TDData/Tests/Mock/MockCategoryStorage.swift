import TDCore
import TDData

final class MockCategoryStorage: CategoryStorage {
    var stubbedFetchCategoriesResult: [TDCategoryDTO] = []
    var stubbedFetchCategoriesError: TDDataError?
    
    var stubbedUpdateCategoriesResult: Result<Void, TDDataError> = .success(())
    var stubbedUpdateCategoriesError: TDDataError?
    
    func fetchCategories() async throws -> [TDCategoryDTO] {
        if let error = stubbedFetchCategoriesError {
            throw error
        }
        return stubbedFetchCategoriesResult
    }
    
    func updateCategories(categories: [TDCategoryDTO]) async throws -> Result<Void, TDDataError> {
        if let error = stubbedUpdateCategoriesError {
            throw error
        }
        return stubbedUpdateCategoriesResult
    }
}
