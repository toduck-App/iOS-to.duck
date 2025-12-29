import Combine
import TDDomain
import Foundation

final class WriteDiaryViewModel: BaseViewModel {
    enum Input {
        case setContent(String)
        case setImages([Data])
        case createDiary
        case createSkipDiary
    }
    
    enum Output {
        case setImage
        case success
        case failure(String)
    }
    
    // MARK: - Properties
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var title: String = ""
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
            case .createSkipDiary:
                Task { await self.createSkipDiary() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func setContent(_ content: String) {
        if content.count > 2000 {
            return
        }
        self.content = content
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
            setTitleIfNeeded()
            let diary = Diary(
                id: 0,
                date: selectedDate,
                emotion: selectedMood,
                title: title,
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
    
    private func createSkipDiary() async {
        do {
            setTitleIfNeeded()
            let diary = Diary(
                id: 0,
                date: selectedDate,
                emotion: selectedMood,
                title: title,
                memo: "",
                diaryImageUrls: nil,
                diaryKeywords: selectedKeyword.map { DiaryKeyword(id: $0.id, keywordName: $0.name) }
            )
            try await createDiaryUseCase.execute(diary: diary, image: nil)
            output.send(.success)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    private func setTitleIfNeeded() {
        guard title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let mood = selectedMood.rawValue
        let moodToKorean: [String: String] = [
            "HAPPY": "기분 좋은 하루",
            "GOOD": "마음이 평온했던 하루",
            "LOVE": "따뜻함이 느껴진 하루",
            "SOSO": "평범하게 흘러간 하루",
            "SICK": "몸과 마음이 힘들었던 하루",
            "SAD": "울컥했던 하루",
            "ANGRY": "신경이 곤두섰던 하루",
            "ANXIOUS": "마음이 불안했던 하루",
            "TIRED": "기운이 빠졌던 하루"
        ]
        
        title = moodToKorean[mood] ?? "좋아용"
    }
}
