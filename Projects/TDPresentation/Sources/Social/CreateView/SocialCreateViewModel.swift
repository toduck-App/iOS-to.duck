import Combine
import Foundation
import TDDesign
import TDDomain

final class SocialCreateViewModel: BaseViewModel {
    enum Input {
        case chipSelect(at: Int)
        case setRoutine(Routine)
        case setContent(String)
        case setImages([Data])
    }
    
    enum Output {
        case createPost
        case setRoutine
        case setImage
        case failure(String)
    }
    
    private(set) var routines: [Routine] = []
    private(set) var selectedCategory: PostCategory?
    private(set) var selectedRoutine: Routine?
    private(set) var images: [Data] = []
    private(set) var title: String = ""
    private(set) var content: String = ""
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var category: PostCategory?
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .chipSelect(let index):
                setCategory(at: index)
            case .setRoutine(let routine):
                setRoutine(routine)
            case .setContent:
                break
            case .setImages(let data):
                setImages(data)
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension SocialCreateViewModel {
    private func setCategory(at index: Int) {
        let category = PostCategory.allCases[safe: index]
        self.category = category
    }
    
    private func setRoutine(_ routine: Routine) {
        selectedRoutine = routine
        output.send(.setRoutine)
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
