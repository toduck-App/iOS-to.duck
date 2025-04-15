import Combine
import Foundation
import TDDomain

final class SocialReportViewModel: BaseViewModel {
    enum Input {
        case typingText(String)
        case checkBlockAuthor(Bool)
        case reportPost
    }
    
    enum Output {
        case reportPostSuccess
        case failure(String)
    }
    
    private let reportPostUseCase: ReportPostUseCase
    private let postID: Post.ID
    private var reason: String?
    private var blockAuthor: Bool = false
    private(set) var reportType: ReportType
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    init(
        postID: Post.ID,
        reportType: ReportType,
        reportPostUseCase: ReportPostUseCase
    ) {
        self.postID = postID
        self.reportType = reportType
        self.reportPostUseCase = reportPostUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .reportPost:
                Task { await self.reportPost() }
            case .typingText(let text):
                reason = text
            case .checkBlockAuthor(let isChecked):
                blockAuthor = isChecked
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func reportPost() async {
        do {
            try await reportPostUseCase.execute(
                postID: postID,
                reportType: reportType,
                reason: reason,
                blockAuthor: blockAuthor
            )
            output.send(.reportPostSuccess)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}
