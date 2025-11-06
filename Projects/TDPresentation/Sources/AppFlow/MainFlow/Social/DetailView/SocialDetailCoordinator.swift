import TDCore
import TDDomain
import UIKit

final class SocialDetailCoordinator: Coordinator, CoordinatorFinishDelegate {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    let postID: Post.ID
    let commentId: Comment.ID?
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        postId: Post.ID,
        commentId: Comment.ID?
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.postID = postId
        self.commentId = commentId
    }
    
    // TODO: CommentID가 넘어왔을 시 해당 댓글로 스크롤 이동
    
    func start() {
        let fetchPostUseCase = injector.resolve(FetchPostUseCase.self)
        let togglePostLikeUseCase = injector.resolve(TogglePostLikeUseCase.self)
        let toggleCommentLikeUseCase = injector.resolve(ToggleCommentLikeUseCase.self)
        let createCommentUseCase =  injector.resolve(CreateCommentUseCase.self)
        let reportPostUseCase = injector.resolve(ReportPostUseCase.self)
        let delteCommentUseCase = injector.resolve(DeleteCommentUseCase.self)
        let blockUserUseCase = injector.resolve(BlockUserUseCase.self)
        
        let socialDetailViewModel = SocialDetailViewModel(
            repo: injector.resolve(SocialRepository.self),
            fetchPostUsecase: fetchPostUseCase,
            togglePostLikeUseCase: togglePostLikeUseCase,
            toggleCommentLikeUseCase: toggleCommentLikeUseCase,
            createCommentUseCase: createCommentUseCase,
            reportPostUseCase: reportPostUseCase,
            deleteCommentUseCase: delteCommentUseCase,
            blockUserUseCase: blockUserUseCase,
            at: postID
        )
        
        let socialDetailViewController = SocialDetailViewController(
            viewModel: socialDetailViewModel
        )
        socialDetailViewController.coordinator = self
        if let commentId {
            socialDetailViewController.updateScrollToCommentId(commentId)
        }
        navigationController.pushTDViewController(socialDetailViewController, animated: true)
    }
    
    func didTapUserProfile(id: User.ID) {
        let socialProfileViewCoordinator = SocialProfileCoordinator(
            navigationController: navigationController,
            injector: injector,
            id: id
        )
        childCoordinators.append(socialProfileViewCoordinator)
        socialProfileViewCoordinator.finishDelegate = self
        socialProfileViewCoordinator.start()
    }
    
    func didTapReportComment(id: Comment.ID) {
        let coordinator = SocialReportCoordinator(navigationController: navigationController, injector: injector, postID: postID, commentID: id)
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    func didFinish(childCoordinator: any Coordinator) {
        finish(by: .pop)
    }
    
    func didTapRoutine(routine: Routine) {
        let coordinator = RoutineShareCoordinator(
            navigationController: navigationController,
            injector: injector,
            routine: routine
        )
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
}
