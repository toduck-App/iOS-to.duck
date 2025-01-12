import Combine
import Foundation
import TDDomain

final class SocialSearchViewModel: BaseViewModel {
    enum Input {
        case loadKeywords
        case deleteRecentKeyword(index: Int)
        case deleteRecentAllKeywords
        case search(query: String)
        case selectPost(post: Post.ID)
        case likePost(at: Int)
        case blockUser(to: User)
    }
    
    enum Output {
        case updateKeywords
        case searchResult
        case selectPost
        case likePost(Post)
        case failure(String)
    }
    
    struct Keyword: Identifiable, Hashable {
        var id = UUID()
        var word: String
    }
    
    private let searchPostUseCase: SearchPostUseCase
    private let togglePostLikeUseCase: TogglePostLikeUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private(set) var recentKeywords: [Keyword] = ["콘서타", "루틴", "불면증"].map { Keyword(word: $0) }
    private(set) var popularKeywords: [Keyword] = ["루틴", "집중", "뽀모도로", "꿀팁", "시간관리", "ADHD", "일기"].map { Keyword(word: $0) }
    private(set) var searchResult: [Post] = []
    private(set) var selectedPostID: Post.ID?
    
    init(searchPostUseCase: SearchPostUseCase,
         togglePostLikeUseCase: TogglePostLikeUseCase,
         blockUserUseCase: BlockUserUseCase)
    {
        self.searchPostUseCase = searchPostUseCase
        self.togglePostLikeUseCase = togglePostLikeUseCase
        self.blockUserUseCase = blockUserUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .loadKeywords:
                Task { await self.loadKeywords() }
            case .deleteRecentKeyword(let index):
                Task { await self.deleteRecentKeyword(index: index) }
            case .deleteRecentAllKeywords:
                Task { await self.deleteAllRecentKeywords() }
            case .search(let term):
                Task { await self.searchPost(term: term) }
            case .selectPost(let post):
                selectPost(postID: post)
            case .likePost(let index):
                Task { await self.likePost(at: index) }
            case .blockUser(let user):
                Task { await self.blockUser(to: user) }
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func searchPost(term: String) async {
        await saveKeywords(term: term)
        do {
            let posts = try await searchPostUseCase.execute(keyword: term)
            searchResult = posts ?? []
            output.send(.searchResult)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    func selectPost(postID: Post.ID) {
        selectedPostID = postID
        output.send(.selectPost)
    }
    
    private func loadKeywords() async {
        // TODO: UserDefault에서 가져오기
        output.send(.updateKeywords)
    }
    
    @MainActor
    private func deleteRecentKeyword(index: Int) async {
        // TODO: UserDefult에 삭제
        recentKeywords.remove(at: index)
        output.send(.updateKeywords)
    }
    
    @MainActor
    private func saveKeywords(term: String) async {
        if let index = recentKeywords.firstIndex(where: { $0.word == term }) {
            let keyword = recentKeywords.remove(at: index)
            recentKeywords.insert(keyword, at: 0)
        } else {
            recentKeywords.insert(Keyword(word: term), at: 0)
        }
    }
    
    @MainActor
    private func deleteAllRecentKeywords() async {
        recentKeywords.removeAll()
        output.send(.updateKeywords)
    }
    
    private func likePost(at index: Int) async {
        do {
            let result = try await togglePostLikeUseCase.execute(postID: searchResult[index].id)
            guard let likeCount = searchResult[index].likeCount else { return }
            searchResult[index].isLike.toggle()
            searchResult[index].likeCount = searchResult[index].isLike ? likeCount + 1 : likeCount - 1
            output.send(.likePost(searchResult[index]))
        } catch {
            output.send(.failure("게시글 좋아요를 실패했습니다."))
        }
    }
    
    private func blockUser(to user: User) async {
        do {
            let result = try await blockUserUseCase.execute(userID: user.id)
            // TODO: ALERT OUTPUT 필요
        } catch {
            output.send(.failure("사용자 차단에 실패했습니다."))
        }
    }
}
