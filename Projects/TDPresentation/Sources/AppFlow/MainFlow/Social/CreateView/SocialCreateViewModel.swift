import Combine
import Foundation
import TDDesign
import TDDomain

final class SocialCreateViewModel: BaseViewModel {
    enum Input {
        case chipSelect(at: Int)
        case setRoutine(Routine)
        case setTitle(String)
        case setContent(String)
        case setImages([Data])
        case createPost
    }
    
    enum Output {
        case canCreatePost(Bool)
        case createPost
        case setRoutine
        case setImage
        case failure(String)
        case success
    }
    
    private(set) var routines: [Routine] = []
    private(set) var selectedCategory: [PostCategory]?
    private(set) var selectedRoutine: Routine?
    private(set) var images: [Data] = []
    private(set) var title: String = ""
    private(set) var content: String = ""
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var category: [PostCategory] = []
    
    private let createPostUseCase: CreatePostUseCase
    
    init(createPostUseCase: CreatePostUseCase) {
        self.createPostUseCase = createPostUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .chipSelect(let index):
                setCategory(at: index)
            case .setRoutine(let routine):
                setRoutine(routine)
            case .setContent(let content):
                setContent(content)
            case .setImages(let data):
                setImages(data)
            case .setTitle(let title):
                setTitle(title)
            case .createPost:
                Task { await self.createPost() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}

extension SocialCreateViewModel {
    private func createPost() async {
        let post = Post(
            title: title,
            content: content,
            routine: selectedRoutine,
            category: category
        )
        
        let image = images.map { ("\(UUID().uuidString).jpeg", $0) }
        do {
            try await createPostUseCase.execute(post: post, image: image)
            output.send(.success)
        } catch {
            output.send(.failure(error.localizedDescription))
        }

    }
    
    private func setTitle(_ title: String) {
        self.title = title
        validateCreatePost()
    }
    private func setCategory(at index: Int) {
        let category = PostCategory.allCases[index]
        
        if self.category.contains(category) {
            self.category.removeAll { $0 == category }
            return
        }
        self.category.append(category)
        validateCreatePost()
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
        validateCreatePost()
    }
    
    private func setImages(_ images: [Data]) {
        if images.count > 5 {
            output.send(.failure("이미지는 최대 5개까지 첨부 가능합니다."))
            return
        }
        self.images = images
        output.send(.setImage)
    }
    
    private func validateCreatePost() {
        if title.isEmpty || content.isEmpty || category.isEmpty {
            output.send(.canCreatePost(false))
            return
        }
        output.send(.canCreatePost(true))
    }
}
