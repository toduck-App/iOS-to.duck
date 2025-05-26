import TDCore
import TDDomain

final class MockUpdateCategoriesUseCase: UpdateCategoriesUseCase {
    var stubbedExecuteResult: Result<Void, TDDataError> = .success(())
    var invokedExecute = false
    var invokedExecuteParameters: [TDCategory]?

    func execute(categories: [TDCategory]) async throws {
        invokedExecute = true
        invokedExecuteParameters = categories
        switch stubbedExecuteResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
