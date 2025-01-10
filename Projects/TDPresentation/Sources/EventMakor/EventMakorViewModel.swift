import Combine
import TDCore
import TDDomain

final class EventMakorViewModel: BaseViewModel {
    enum Input {
        case fetchCategories
        case selectCategory(String)
    }
    
    enum Output {
        case fetchedCategories
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var categories: [String] = []
    private var selectedCategory: String?
    
    init(fetchCategoriesUseCase: FetchCategoriesUseCase) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchCategories:
                Task { await self?.fetchCategories() }
            case .selectCategory(let category):
                self?.selectedCategory = category
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
