import Combine
import Foundation
import TDDesign
import TDDomain

final class SocialCreateViewModel: BaseViewModel {
    enum Input {
        case fetchRoutines
        case chipSelect(at: Int)
        case setRoutine(Routine)
        case setContent(String)
        case setImages([Data])
    }
    
    enum Output {
        case success
        case setImage
        case notSelectCategory
        case failure(String)
    }
    
    private let fetchRoutineListUseCase: FetchRoutineListUseCase
    
    private(set) var chips: [TDChipItem] = PostCategory.allCases.map { TDChipItem(title: $0.rawValue) }
    private(set) var routines: [Routine] = []
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var category: PostCategory?
    private var selectedRoutine: Routine?
    private var content: String = ""
    private(set) var images: [Data] = []
    
    init(fetchRoutineListUseCase: FetchRoutineListUseCase) {
        self.fetchRoutineListUseCase = fetchRoutineListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .chipSelect(let index):
                self.setCategory(at: index)
            case .setRoutine:
                break
            case .setContent:
                break
            case .setImages(let data):
                self.setImages(data)
            case .fetchRoutines:
                Task { await self.fetchRoutines() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension SocialCreateViewModel {
    private func fetchRoutines() async {
        do {
            let routines = try await fetchRoutineListUseCase.execute()
            self.routines = routines
            output.send(.success)
        } catch {
            output.send(.failure("루틴을 불러오는데 실패했습니다."))
        }
        
    }
    
    private func setCategory(at index: Int) {
        guard let category = PostCategory(rawValue: chips[index].title) else { return }
        self.category = category
    }
    
    private func setRoutine(_ routine: Routine) {
        self.selectedRoutine = routine
    }
    
    private func setContent(_ content: String) {
        if content.count > 500 {
            return
        }
        self.content = content
    }
    
    private func setImages(_ images: [Data]) {
        if images.count > 5 {
            output.send(.failure("이미지는 최대 5개까지 첨부 가능합니다."))
            return
        }
        self.images = images
        output.send(.setImage)
    }
}
