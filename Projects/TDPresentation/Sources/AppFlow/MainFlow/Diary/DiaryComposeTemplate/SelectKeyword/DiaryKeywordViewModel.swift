import Combine
import TDDomain
import Foundation

final class DiaryKeywordViewModel: BaseViewModel {
    enum Input {
        case fetchKeywords
        case toggleKeyword(DiaryKeyword)
        case selectCategory(DiaryKeywordCategory?)
        case addKeywords(String, DiaryKeywordCategory)
        case deleteKeyword(DiaryKeyword)
    }
    
    enum Output {
        case updateKeywords(DiaryKeywordDictionary)
        case updateSelection
        case failure(String)
    }
    
    // MARK: - Properties
    private(set) var selectedKeywords: [DiaryKeyword] = []
    private(set) var currentCategory: DiaryKeywordCategory? = nil
    private(set) var keywordDictionary: DiaryKeywordDictionary = [:]

    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String
    private(set) var selectedDate: Date
    
    private let fetchDiaryKeywordsUseCase: FetchDiaryKeywordUseCase
    
    // MARK: - Initializer
    
    init(
        selectedMood: String,
        selectedDate: Date,
        fetchDiaryKeywordsUseCase: FetchDiaryKeywordUseCase
    ) {
        self.selectedMood = selectedMood
        self.selectedDate = selectedDate
        self.fetchDiaryKeywordsUseCase = fetchDiaryKeywordsUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .fetchKeywords:
                Task { await self.fetchKeywords() }
            case .toggleKeyword(let keyword):
                if selectedKeywords.contains(where: { $0.id == keyword.id }) {
                    selectedKeywords.removeAll { $0.id == keyword.id }
                } else {
                    selectedKeywords.append(keyword)
                }
                self.output.send(.updateSelection)
            case .selectCategory(let category):
                currentCategory = category
                let filteredKeywords = self.filterKeywords()
                self.output.send(.updateKeywords(filteredKeywords))
            case .addKeywords(_, _):
                break
            case .deleteKeyword(_):
                break
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchKeywords() async {
        do {
            let diaryKeywordsResult = try await fetchDiaryKeywordsUseCase.execute()
            keywordDictionary = diaryKeywordsResult
            output.send(.updateKeywords(keywordDictionary))
        } catch {
            output.send(.failure("키워드를 불러오기 실패 했어요"))
        }
    }
    
    private func filterKeywords() -> DiaryKeywordDictionary {
        guard let currentCategory else {
            return keywordDictionary
        }
        return [currentCategory: keywordDictionary[currentCategory] ?? []]
    }

}
