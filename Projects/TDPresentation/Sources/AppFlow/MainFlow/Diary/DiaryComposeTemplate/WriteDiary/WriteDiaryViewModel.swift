import Combine
import TDDomain
import Foundation

final class WriteDiaryViewModel: BaseViewModel {
    enum Input {
        case setContent(String)
        case setImages([Data])
        case createDiary
    }
    
    enum Output {
        case setImage
        case enableSaveButton(Bool)
        case success
        case failure(String)
    }
    
    // MARK: - Properties
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var content: String = ""
    private(set) var images: [Data] = []
    private(set) var selectedMood: Emotion
    private(set) var selectedDate: Date
    private(set) var selectedKeyword: [UserKeyword] = []
    
    private let createDiaryUseCase: CreateDiaryUseCase
    
    // MARK: - Initializer
    
    init(
        selectedMood: Emotion,
        selectedDate: Date,
        selectedKeyword: [UserKeyword],
        createDiaryUseCase: CreateDiaryUseCase,
    ) {
        self.selectedMood = selectedMood
        self.selectedDate = selectedDate
        self.selectedKeyword = selectedKeyword
        self.createDiaryUseCase = createDiaryUseCase
    }
    
    // MARK: - Transform
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .setContent(let content):
                setContent(content)
            case .setImages(let data):
                setImages(data)
            case .createDiary:
                Task { await self.createDiary() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func setContent(_ content: String) {
        if content.count > 500 {
            return
        }
        self.content = content
        output.send(.enableSaveButton(!content.isEmpty))
    }
    
    private func setImages(_ images: [Data], _ isEditImage: Bool = false) {
        if images.count > 2 {
            output.send(.failure("이미지는 최대 2개까지 첨부 가능합니다."))
            return
        }
        self.images = images
        output.send(.setImage)
    }
    
    private func createDiary() async {
        do {
            let diary = Diary(
                id: 0,
                date: selectedDate,
                emotion: selectedMood,
                title: "",
                memo: content,
                diaryImageUrls: nil,
                diaryKeywords: selectedKeyword.map { DiaryKeyword(id: $0.id, keywordName: $0.name) }
            )
            let image = images.map { ("\(UUID().uuidString).jpg", $0) }
            try await createDiaryUseCase.execute(diary: diary, image: image)
            output.send(.success)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}
