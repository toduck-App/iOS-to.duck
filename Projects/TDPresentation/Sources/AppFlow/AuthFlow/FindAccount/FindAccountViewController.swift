import Combine
import UIKit
import TDCore
import TDDesign

final class FindAccountViewController: BaseViewController<BaseView> {
    private let segmentedControl = UISegmentedControl(items: ["아이디 찾기", "비밀번호 찾기"])
    
    private var currentViewController: UIViewController?
    weak var coordinator: FindAccountCoordinator?
    
    override func configure() {
        view.backgroundColor = TDColor.baseWhite
        setupSegmentedControl()
        updateView()
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        segmentedControl.addAction(UIAction { [weak self] _ in
            self?.updateView()
        }, for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - View Update
    private func updateView() {
        let newViewController = getViewController(for: segmentedControl.selectedSegmentIndex)
        guard currentViewController !== newViewController else { return }
        
        replaceCurrentViewController(with: newViewController)
    }
    
    private func getViewController(for index: Int) -> UIViewController {
        switch index {
        case 0:
            let viewModel = FindIdViewModel()
            return FindIdViewController(viewModel: viewModel)
        case 1:
            let viewModel = FindPasswordViewModel()
            return FindPasswordViewController(viewModel: viewModel)
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
