import Combine
import TDDomain
import Foundation

final class DiaryMakorViewModel: BaseViewModel {
    enum Input {
        case tapCategoryCell(String)
        case updateTitleTextField(String)
        case updateMemoTextView(String)
        case setImages([Data])
        case tapSaveButton
        case tapEditButton
    }
    
    enum Output {
        case setImage
        case savedDiary
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
    private(set) var images: [Data] = []
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
        let shared = input.share()
        
        shared
            .filter {
                switch $0 {
                case .tapSaveButton, .tapEditButton:
                    return false
                default:
                    return true
                }
            }
            .sink { [weak self] event in
                switch event {
                case .tapCategoryCell(let mood):
                    self?.selectedMood = mood
                case .updateTitleTextField(let title):
                    self?.title = title
                case .updateMemoTextView(let memo):
                    self?.memo = memo
                case .setImages(let datas):
                    self?.setImages(datas)
                default:
                    break
                }
            }.store(in: &cancellables)
        
        shared
            .filter {
                switch $0 {
                case .tapSaveButton, .tapEditButton:
                    return true
                default:
                    return false
                }
            }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] event in
                switch event {
                case .tapSaveButton:
                    Task { await self?.saveDiary() }
                case .tapEditButton:
                    Task { await self?.editDiary() }
                default:
                    break
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
    
    private func setImages(_ images: [Data]) {
        if images.count > 2 {
            output.send(.failure("이미지는 최대 2개까지 첨부 가능합니다."))
            return
        }
        self.images = images
        output.send(.setImage)
    }
    
    private func saveDiary() async {
        do {
            setTitleIfNeeded()
            let diary = createDiaryObject()
            let image = images.map { ("\(UUID().uuidString).jpg", $0) }
            try await createDiaryUseCase.execute(diary: diary, image: image)
            output.send(.savedDiary)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    private func setTitleIfNeeded() {
        guard title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true else {
            return
        }
        
        guard let mood = selectedMood else {
            title = "무제"
            return
        }
        
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
    
    private func editDiary() async {
        guard let preDiary else { return }
        
        do {
            let isChangeEmotion = preDiary.emotion.rawValue != selectedMood
            let updatedDiary = createDiaryObject(id: preDiary.id)
            
            try await updateDiaryUseCase.execute(
                isChangeEmotion: isChangeEmotion,
                diary: updatedDiary,
                image: nil
            )
            output.send(.savedDiary)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}

