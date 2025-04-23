import Combine
import Foundation
import TDDomain

final class SocialReportViewModel: BaseViewModel {
    enum Input {
        case typingText(String)
        case checkBlockAuthor(Bool)
        case report
    }
    
    enum Output {
        case success
        case failure(String)
    }
    
    private let reportPostUseCase: ReportPostUseCase
    private let reportCommentUseCase: ReportCommentUseCase
    private let postID: Post.ID
    private let commentID: Comment.ID?
    private var reason: String?
    private var blockAuthor: Bool = false
    private(set) var reportType: ReportType
    
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<Output, Never>()
    
    init(
        postID: Post.ID,
        commentID: Comment.ID?,
        reportType: ReportType,
        reportPostUseCase: ReportPostUseCase,
        reportCommentUseCase: ReportCommentUseCase
    ) {
        self.postID = postID
        self.commentID = commentID
        self.reportType = reportType
        self.reportPostUseCase = reportPostUseCase
        self.reportCommentUseCase = reportCommentUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .report:
                Task { self.commentID != nil ? await self.reportComment() : await self.reportPost() }
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
            output.send(.success)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
    
    private func reportComment() async {
        do {
            guard let commentID else { return }
            try await reportCommentUseCase.execute(
                postID: postID,
                commentID: commentID,
                reportType: reportType,
                reason: reason,
                blockAuthor: blockAuthor
            )
            output.send(.success)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}
