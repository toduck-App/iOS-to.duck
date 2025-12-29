import Combine
import TDDomain
import Foundation

final class DiaryKeywordViewModel: BaseViewModel {
    enum Mode {
        case normal
        case remove
    }
    
    enum Input {
        case fetchKeywords
        case clearKeywords
        case toggleKeyword(UserKeyword)
        case selectCategory(UserKeywordCategory?)
        case changeMode(Mode)
        case clearDeleteKeywords
        case deleteKeywords
    }
    
    enum Output {
        /// 실제 데이터 셋(섹션/아이템)이 변경될 때
        case updateKeywords(DiaryKeywordDictionary)
        /// 현재 snapshot 안에서 선택 상태 / 모드만 바뀔 때
        case updateSelection
        /// 키워드 스택 뷰 관리용
        case updateSelectedKeywords([UserKeyword])
        case failure(String)
    }
    
    // MARK: - Properties
    private(set) var currentMode: Mode = .normal
    private(set) var selectedKeywords: [UserKeyword] = []
    private(set) var removedKeywords: [UserKeyword] = []
    private(set) var currentCategory: UserKeywordCategory? = nil
    private(set) var keywordDictionary: DiaryKeywordDictionary = [:]

    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var selectedMood: Emotion?
    private(set) var selectedDate: Date?
    
    private let fetchDiaryKeywordsUseCase: FetchDiaryKeywordUseCase
    private let createDiaryKeywordUseCase: CreateDiaryKeywordUseCase
    private let deleteDiaryKeywordUseCase: DeleteDiaryKeywordUseCase
    
    // MARK: - Initializer
    init(
        selectedMood: Emotion?,
        selectedDate: Date?,
        fetchDiaryKeywordsUseCase: FetchDiaryKeywordUseCase,
        createDiaryKeywordUseCase: CreateDiaryKeywordUseCase,
        deleteDiaryKeywordUseCase: DeleteDiaryKeywordUseCase
    ) {
        self.selectedMood = selectedMood
        self.selectedDate = selectedDate
        self.fetchDiaryKeywordsUseCase = fetchDiaryKeywordsUseCase
        self.createDiaryKeywordUseCase = createDiaryKeywordUseCase
        self.deleteDiaryKeywordUseCase = deleteDiaryKeywordUseCase
    }
    
    // MARK: - Transform
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self else { return }
                
                switch event {
                case .fetchKeywords:
                    Task { await self.fetchKeywords() }
                    
                case .clearKeywords:
                    self.selectedKeywords.removeAll()
                    self.output.send(.updateSelection)
                    self.output.send(.updateSelectedKeywords(selectedKeywords))
                case .toggleKeyword(let keyword):
                    switch self.currentMode {
                    case .normal:
                        self.appendSelectedKeyword(keyword: keyword)
                    case .remove:
                        self.appendRemovedKeyword(keyword: keyword)
                    }
                    self.output.send(.updateSelection)
                    self.output.send(.updateSelectedKeywords(selectedKeywords))
                case .selectCategory(let category):
                    self.currentCategory = category
                    let filtered = self.filterKeywords()
                    self.output.send(.updateKeywords(filtered))
                    
                case .changeMode(let mode):
                    self.currentMode = mode
                    self.output.send(.updateSelection)
                case .clearDeleteKeywords:
                    self.clearRemoveKeywords()
                    
                case .deleteKeywords:
                    Task { await self.deleteKeyword() }
                }
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

// MARK: - Private methods
private extension DiaryKeywordViewModel {
    /// 전체 키워드 fetch 후 snapshot 재적용
    func fetchKeywords() async {
        do {
            let diaryKeywordsResult = try await fetchDiaryKeywordsUseCase.execute()
            keywordDictionary = diaryKeywordsResult
            
            let filtered = filterKeywords()
            output.send(.updateKeywords(filtered))
        } catch {
            output.send(.failure("키워드를 불러오는데 실패했어요"))
        }
    }
    
    /// 현재 선택된 카테고리 기준으로 필터링된 딕셔너리 반환
    func filterKeywords() -> DiaryKeywordDictionary {
        guard let currentCategory else {
            return keywordDictionary
        }
        return [currentCategory: keywordDictionary[currentCategory] ?? []]
    }
    
    /// 실제 삭제 로직 + keywordDictionary 갱신 + snapshot 재적용
    func deleteKeyword() async {
        do {
            try await deleteDiaryKeywordUseCase.execute(keywords: removedKeywords)
            
            selectedKeywords.removeAll { selected in
                removedKeywords.contains(where: { $0.id == selected.id })
            }
            
            for (category, keywords) in keywordDictionary {
                let filtered = keywords.filter { keyword in
                    removedKeywords.contains(where: { $0.id == keyword.id }) == false
                }
                keywordDictionary[category] = filtered
            }
            
            keywordDictionary = keywordDictionary.filter { (_, keywords) in
                keywords.isEmpty == false
            }
            
            clearRemoveKeywords()
            
            let filtered = filterKeywords()
            output.send(.updateKeywords(filtered))
            output.send(.updateSelectedKeywords(selectedKeywords))
        } catch {
            output.send(.failure("키워드 삭제에 실패 했어요"))
        }
    }
    
    func appendSelectedKeyword(keyword: UserKeyword) {
        if selectedKeywords.contains(where: { $0.id == keyword.id }) {
            selectedKeywords.removeAll { $0.id == keyword.id }
        } else {
            selectedKeywords.append(keyword)
        }
    }
    
    func appendRemovedKeyword(keyword: UserKeyword) {
        if removedKeywords.contains(where: { $0.id == keyword.id }) {
            removedKeywords.removeAll { $0.id == keyword.id }
        } else {
            removedKeywords.append(keyword)
        }
    }
    
    func clearRemoveKeywords() {
        removedKeywords = []
        output.send(.updateSelection)
    }
}
