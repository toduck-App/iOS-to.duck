import Combine
import Foundation
import TDDesign
import TDDomain

final class SocialCreateViewModel: BaseViewModel {
    enum Input {
        case setCategory(PostCategory)
        case setRoutine(Routine)
        case setContent(String)
        case setImages([Data?])
    }
    
    enum Output {
        case success
        case failure(String)
    }
    
    private(set) var chips: [TDChipItem] = PostCategory.allCases.map { TDChipItem(title: $0.rawValue) }
    
    private let output = PassthroughSubject<Output, Never>()
    private var category: PostCategory?
    private var routine: Routine?
    private var content: String = ""
    private var images: [Data?] = []
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output.eraseToAnyPublisher()
    }
}

extension SocialCreateViewModel {
    private func setCategory(_ category: PostCategory) {
        self.category = category
    }
    
    private func setRoutine(_ routine: Routine) {
        self.routine = routine
    }
    
    private func setContent(_ content: String) {
        if content.count > 500 {
            return
        }
        self.content = content
    }
    
    private func setImages(_ images: [Data?]) {
        if images.count > 5 {
            output.send(.failure("이미지는 최대 5개까지 첨부 가능합니다."))
            return
        }
        self.images = images
    }
}
