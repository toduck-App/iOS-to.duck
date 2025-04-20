import FittedSheets
import TDCore
import TDDomain
import UIKit

protocol SocialReportDelegate {
    func didTapReportType(_ type: ReportType)
    func didTapReport()
}

enum ReportViewType {
    case post
    case comment
}

final class SocialReportCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    var postID: Post.ID
    var commentID: Comment.ID?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        postID: Post.ID,
        commentID: Comment.ID? = nil
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.postID = postID
        self.commentID = commentID
    }

    func start() {
        let reportViewType: ReportViewType = commentID == nil ? .post : .comment
        let controller = SocialReportViewController(reportViewType: reportViewType)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.fixed(410)],
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        controller.coordinator = self
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true, completion: nil)
    }
}

extension SocialReportCoordinator: SocialReportDelegate {
    func didTapReportType(_ type: ReportType) {
        navigationController.viewControllers.last?.dismiss(animated: true, completion: nil)
        let reportPostUseCase = injector.resolve(ReportPostUseCase.self)
        let reportCommentUseCase = injector.resolve(ReportCommentUseCase.self)
        let viewModel = SocialReportViewModel(
            postID: postID,
            commentID: commentID,
            reportType: type,
            reportPostUseCase: reportPostUseCase,
            reportCommentUseCase: reportCommentUseCase
        )
        let sizes: [SheetSize] = type == .custom ? [.fixed(480)] : [.fixed(320)]
        let controller = SocialReportDetailViewController(viewModel: viewModel)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: sizes,
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        controller.coordinator = self
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true, completion: nil)
    }

    func didTapReport() {
        navigationController.viewControllers.last?.dismiss(animated: true, completion: nil)
    }
}
