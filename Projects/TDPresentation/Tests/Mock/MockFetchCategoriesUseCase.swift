import TDDomain

final class MockFetchCategoriesUseCase: FetchCategoriesUseCase {
    var stubbedExecuteResult: [TDCategory] = []
    var invokedExecute = false

    func execute() async throws -> [TDCategory] {
        invokedExecute = true
        return stubbedExecuteResult
    }
}
