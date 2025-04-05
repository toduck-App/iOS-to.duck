import Combine
import TDDomain
import Foundation

final class DiaryMakorViewModel: BaseViewModel {
    enum Input {
        case tapCategoryCell(String)
        case updateTitleTextField(String)
        case updateMemoTextView(String)
        case tapSaveButton
    }
    
    enum Output {
        case failure(String)
    }
    
    private let createDiaryUseCase: CreateDiaryUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String?
    private(set) var selectedDate: Date?
    private(set) var title: String?
    private(set) var memo: String?
    private(set) var preDiary: Diary?
    
    init(
        createDiaryUseCase: CreateDiaryUseCase,
        selectedDate: Date? = nil,
        preDiary: Diary? = nil
    ) {
        self.createDiaryUseCase = createDiaryUseCase
        self.selectedDate = selectedDate
        self.preDiary = preDiary
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .tapCategoryCell(let mood):
                self?.selectedMood = mood
            case .updateTitleTextField(let title):
                self?.title = title
            case .updateMemoTextView(let memo):
                self?.memo = memo
            case .tapSaveButton:
                Task { await self?.saveDiary() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func saveDiary() async {
        do {
            let diary = Diary(
                id: 0,
                date: selectedDate ?? Date(),
                emotion: Emotion(rawValue: selectedMood ?? "") ?? .angry,
                title: title ?? "",
                memo: memo ?? "",
                diaryImageUrls: nil
            )
            try await createDiaryUseCase.execute(diary: diary)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}

