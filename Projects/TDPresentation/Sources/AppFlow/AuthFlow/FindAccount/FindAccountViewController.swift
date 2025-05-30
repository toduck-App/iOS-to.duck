import Combine
import TDDomain
import UIKit
import TDCore
import TDDesign

final class FindAccountViewController: BaseViewController<BaseView> {
    private let segmentedControl = TDSegmentedControl(
        items: ["아이디 찾기", "비밀번호 찾기"],
        indicatorForeGroundColor: TDColor.Primary.primary500,
        indicatorBackGroundColor: TDColor.Neutral.neutral400,
        selectedTextColor: TDColor.Primary.primary500,
        normalTextColor: TDColor.Neutral.neutral500
    )
    
    private var currentViewController: UIViewController?
    weak var coordinator: FindAccountCoordinator?
    
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        navigationItem.title = "아이디 · 비밀번호 찾기"
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
        setupSegmentedControl()
        updateView()
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        segmentedControl.addAction(UIAction { [weak self] _ in
            self?.updateView()
        }, for: .valueChanged)
    }
    
    // MARK: - View Update
    private func updateView() {
        let newViewController = getViewController(for: segmentedControl.selectedIndex)
        guard currentViewController !== newViewController else { return }
        
        replaceCurrentViewController(with: newViewController)
    }
    
    private func getViewController(for index: Int) -> UIViewController {
        switch index {
        case 0:
            let findUserIdUseCase = DIContainer.shared.resolve(FindUserIdUseCase.self)
            let requestVerificationCodeForFindUserUseCase = DIContainer.shared.resolve(RequestVerificationCodeForFindUserUseCase.self)
            let verifyPhoneCodeUseCase = DIContainer.shared.resolve(VerifyPhoneCodeUseCase.self)
            let viewModel = FindIdViewModel(
                findUserIdUseCase: findUserIdUseCase,
                requestVerificationCodeForFindUserUseCase: requestVerificationCodeForFindUserUseCase,
                verifyPhoneCodeUseCase: verifyPhoneCodeUseCase
            )
            let findIdViewController = FindIdViewController(viewModel: viewModel)
            findIdViewController.coordinator = coordinator
            return UINavigationController(rootViewController: findIdViewController)
        case 1:
            let requestVerificationCodeForFindUserUseCase = DIContainer.shared.resolve(RequestVerificationCodeForFindUserUseCase.self)
            let requestValidFindUserUseCase = DIContainer.shared.resolve(RequestValidFindUserUseCase.self)
            let verifyPhoneCodeUseCase = DIContainer.shared.resolve(VerifyPhoneCodeUseCase.self)
            let viewModel = FindPasswordViewModel(
                requestVerificationCodeForFindUserUseCase: requestVerificationCodeForFindUserUseCase,
                verifyPhoneCodeUseCase: verifyPhoneCodeUseCase,
                requestValidFindUserUseCase: requestValidFindUserUseCase
            )
            let findPasswordViewController = FindPasswordViewController(viewModel: viewModel)
            findPasswordViewController.coordinator = coordinator
            return UINavigationController(rootViewController: findPasswordViewController)
        default:
            return UIViewController()
        }
    }
    
    private func replaceCurrentViewController(with newViewController: UIViewController) {
        // 기존 뷰 컨트롤러 제거
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        // 새 뷰 컨트롤러 추가
        addChild(newViewController)
        view.addSubview(newViewController.view)
        
        newViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
}
