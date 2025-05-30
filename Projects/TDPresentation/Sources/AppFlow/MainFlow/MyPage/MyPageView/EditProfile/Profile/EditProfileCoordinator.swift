import UIKit
import TDCore
import TDDomain

final class EditProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start(nickName: String, imageUrl: String?) {
        let updateUserNicknameUseCase = injector.resolve(UpdateUserNicknameUseCase.self)
        let updateProfileImageUseCase = injector.resolve(UpdateProfileImageUseCase.self)
        let viewModel = EditProfileViewModel(
            updateUserNicknameUseCase: updateUserNicknameUseCase,
            updateProfileImageUseCase: updateProfileImageUseCase,
            nickName: nickName
        )
        let editProfileViewController = EditProfileViewController(viewModel: viewModel)
        editProfileViewController.hidesBottomBarWhenPushed = true
        editProfileViewController.coordinator = self
        editProfileViewController.updateNickName(nickName: nickName)
        editProfileViewController.updateProfileImage(imageUrl: imageUrl)
        navigationController.pushTDViewController(editProfileViewController, animated: true)
    }
    
    func start() { }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
