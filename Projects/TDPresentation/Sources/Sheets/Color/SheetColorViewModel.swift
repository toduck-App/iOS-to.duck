import Combine
import TDCore
import TDDomain

final class SheetColorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case updateCategoryColor(Int, String)
        case saveCategory
    }
    
    enum Output {
        case fetchedCategories
        case updatedCategoryColor
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private let updateCategoriesUseCase: UpdateCategoriesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var categories: [TDCategory] = []
    
    init(
        fetchCategoriesUseCase: FetchCategoriesUseCase,
        updateCategoriesUseCase: UpdateCategoriesUseCase
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.updateCategoriesUseCase = updateCategoriesUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchCategories:
                Task { await self?.fetchCategories() }
            case .updateCategoryColor(let index, let color):
                self?.handleUpdateCategoryColor(index: index, color: color)
            case .saveCategory:
                Task { await self?.updateCategory(categories: self?.categories ?? []) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchCategories() async {
        do {
            let categories = try await fetchCategoriesUseCase.execute()
            self.categories = categories
            output.send(.fetchedCategories)
        } catch {
            TDLogger.error(error)
        }
    }
    
    private func handleUpdateCategoryColor(index: Int, color: String) {
        guard index >= 0 && index < categories.count else { return }
        categories[index] = createUpdatedCategory(at: index, with: color)
    }
    
    private func createUpdatedCategory(at index: Int, with color: String) -> TDCategory {
        let currentCategory = categories[index]
        return TDCategory(colorHex: color, imageName: currentCategory.imageName)
    }
    
    private func updateCategory(categories: [TDCategory]) async {
        do {
            try await updateCategoriesUseCase.execute(categories: categories)
            output.send(.updatedCategoryColor)
        } catch {
            TDLogger.error(error)
        }
    }
}
