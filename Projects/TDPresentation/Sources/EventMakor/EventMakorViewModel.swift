import Combine
import TDCore
import TDDomain

final class EventMakorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case selectCategory(String, Int)
    }
    
    enum Output {
        case fetchedCategories
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var categories: [String] = []
    private var selectedCategory: String?
    private var selectedCategoryIndex: Int?
    
    init(fetchCategoriesUseCase: FetchCategoriesUseCase) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchCategories:
                Task { await self?.fetchCategories() }
            case .selectCategory(let category, let index):
                self?.selectedCategory = category
                self?.selectedCategoryIndex = index
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
            // TODO: Handle error
            TDLogger.error(error)
        }
    }
}
