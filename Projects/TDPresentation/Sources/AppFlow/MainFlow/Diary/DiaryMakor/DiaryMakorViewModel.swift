import Combine
import TDDomain
import Foundation

final class DiaryMakorViewModel: BaseViewModel {
    enum Input {
        case tapCategoryCell(String)
        case updateTitleTextField(String)
        case updateMemoTextView(String)
        case tapSaveButton
        case tapEditButton
    }
    
    enum Output {
        case saveDiary
        case failure(String)
    }
    
    private let createDiaryUseCase: CreateDiaryUseCase
    private let updateDiaryUseCase: UpdateDiaryUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var selectedMood: String?
    private(set) var selectedDate: Date?
    private(set) var title: String?
    private(set) var memo: String?
    private(set) var preDiary: Diary?
    
    init(
        createDiaryUseCase: CreateDiaryUseCase,
        updateDiaryUseCase: UpdateDiaryUseCase,
        selectedDate: Date? = nil,
        preDiary: Diary? = nil
    ) {
        self.createDiaryUseCase = createDiaryUseCase
        self.updateDiaryUseCase = updateDiaryUseCase
        self.selectedDate = selectedDate
        self.preDiary = preDiary
        self.selectedMood = preDiary?.emotion.rawValue
        self.title = preDiary?.title
        self.memo = preDiary?.memo
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
            case .tapEditButton:
                Task { await self?.editDiary() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func createDiaryObject(id: Int = 0) -> Diary {
        return Diary(
            id: id,
            date: selectedDate ?? Date(),
            emotion: Emotion(rawValue: selectedMood ?? "") ?? .angry,
            title: title ?? "",
            memo: memo ?? "",
            diaryImageUrls: nil
        )
    }

    private func saveDiary() async {
        do {
            let diary = createDiaryObject()
            try await createDiaryUseCase.execute(diary: diary)
            output.send(.saveDiary)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }

    private func editDiary() async {
        guard let preDiary else { return }

        do {
            let isChangeEmotion = preDiary.emotion.rawValue != selectedMood
            let updatedDiary = createDiaryObject(id: preDiary.id)

            try await updateDiaryUseCase.execute(
                isChangeEmotion: isChangeEmotion,
                diary: updatedDiary
            )
            output.send(.saveDiary)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}

