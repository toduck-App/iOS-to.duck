import Combine
import TDDomain
import Foundation

final class DiaryKeywordViewModel: BaseViewModel {
    enum Input {
        case fetchKeywords
        case clearKeywords
        case toggleKeyword(DiaryKeyword)
        case selectCategory(DiaryKeywordCategory?)
        case createKeyword(String, DiaryKeywordCategory)
        case deleteKeyword([DiaryKeyword])
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
    private(set) var selectedMood: Emotion
    private(set) var selectedDate: Date
    
    private let fetchDiaryKeywordsUseCase: FetchDiaryKeywordUseCase
    private let createDiaryKeywordUseCase: CreateDiaryKeywordUseCase
    private let deleteDiaryKeywordUseCase: DeleteDiaryKeywordUseCase
    
    // MARK: - Initializer
    
    init(
        selectedMood: Emotion,
        selectedDate: Date,
        fetchDiaryKeywordsUseCase: FetchDiaryKeywordUseCase,
        createDiaryKeywordUseCase: CreateDiaryKeywordUseCase,
        deleteDiaryKeywordUseCase: DeleteDiaryKeywordUseCase
    ) {
        self.selectedMood = selectedMood
        self.selectedDate = selectedDate
        self.fetchDiaryKeywordsUseCase = fetchDiaryKeywordsUseCase
        self.createDiaryKeywordUseCase = createDiaryKeywordUseCase
        self.deleteDiaryKeywordUseCase = deleteDiaryKeywordUseCase    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .fetchKeywords:
                self.fetchKeywords()
            case .clearKeywords:
                selectedKeywords.removeAll()
                self.output.send(.updateSelection)
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
            case .createKeyword(let name, let category):
                self.addKeyword(name: name, category: category)
            case .deleteKeyword(let keywords):
                self.deleteKeyword(keyword: keywords)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchKeywords() {
        let diaryKeywordsResult = fetchDiaryKeywordsUseCase.execute()
        keywordDictionary = diaryKeywordsResult
        output.send(.updateKeywords(keywordDictionary))
    }
    
    private func filterKeywords() -> DiaryKeywordDictionary {
        guard let currentCategory else {
            return keywordDictionary
        }
        return [currentCategory: keywordDictionary[currentCategory] ?? []]
    }
    
    private func addKeyword(name: String, category: DiaryKeywordCategory) {
        do {
            try createDiaryKeywordUseCase.execute(name: name, category: category)
        } catch {
            output.send(.failure("키워드 추가에 실패 했어요"))
        }
    }
    
    private func deleteKeyword(keyword: [DiaryKeyword]) {
        do {
            try deleteDiaryKeywordUseCase.execute(keywords: keyword)
        } catch {
            output.send(.failure("키워드 삭제에 실패 했어요"))
        }
    }
}
