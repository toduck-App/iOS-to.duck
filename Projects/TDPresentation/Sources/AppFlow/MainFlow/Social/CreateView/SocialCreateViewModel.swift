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
        case setImages([Data], Bool)
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
    private(set) var prevPost: Post? = nil
    private var isEditMode: Bool {
        prevPost != nil
    }
    private var isChangeImage: Bool = false

    private(set) var canCreatePost: Bool = false
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var category: [PostCategory] = []
    
    private let createPostUseCase: CreatePostUseCase
    private let UpdatePostUseCase: UpdatePostUseCase
    
    init(createPostUseCase: CreatePostUseCase,
         UpdatePostUseCase: UpdatePostUseCase,
         prevPost: Post? = nil)
    {
        self.createPostUseCase = createPostUseCase
        self.UpdatePostUseCase = UpdatePostUseCase
        self.prevPost = prevPost
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        let shared = input.share()

        shared
            .filter { event in
                if case .createPost = event {
                    return false
                }
                return true
            }
            .sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .chipSelect(let index):
                setCategory(at: index)
            case .setRoutine(let routine):
                setRoutine(routine)
            case .setContent(let content):
                setContent(content)
            case .setImages(let data, let isEditImage):
                setImages(data, isEditImage)
            case .setTitle(let title):
                setTitle(title)
            default:
                break
            }
        }.store(in: &cancellables)
        
        shared
            .filter { event in
                if case .createPost = event {
                    return true
                }
                return false
            }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] event in
                if case .createPost = event {
                    Task { self?.isEditMode ?? false ? await self?.editPost() : await self?.createPost() }
                }
            }
            .store(in: &cancellables)
        
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
        
        let image = images.map { ("\(UUID().uuidString).jpg", $0) }
        do {
            try await createPostUseCase.execute(post: post, image: image)
            output.send(.success)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    private func editPost() async {
        do {
            guard let prevPost else { return }
            let imageList = isChangeImage ? images.map { ("\(UUID().uuidString).jpg", $0) } : nil
            let updatePost = Post(title: title, content: content, routine: selectedRoutine, category: category)
            try await UpdatePostUseCase.execute(prevPost: prevPost, updatePost: updatePost, image: imageList)
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
    
    private func setImages(_ images: [Data], _ isEditImage: Bool = false) {
        if images.count > 5 {
            output.send(.failure("이미지는 최대 5개까지 첨부 가능합니다."))
            return
        }
        self.images = images
        if isEditImage {
            isChangeImage = true
        }
        output.send(.setImage)
    }
    
    private func validateCreatePost() {
        if title.isEmpty || content.isEmpty || category.isEmpty {
            canCreatePost = false
            output.send(.canCreatePost(canCreatePost))
            return
        }
        canCreatePost = true
        output.send(.canCreatePost(canCreatePost))
    }
}
