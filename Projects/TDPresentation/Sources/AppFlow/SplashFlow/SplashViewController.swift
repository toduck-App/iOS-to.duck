import Combine
import SnapKit
import TDCore
import TDDesign
import UIKit

final class SplashViewController: BaseViewController<BaseView> {
    weak var coordinator: SplashCoordinator?
    private let logoImageView = UIImageView(image: TDImage.toduckPrimaryLogo)
    private let input = PassthroughSubject<SplashViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.send(.validateVerison)
    }
    
    override func addView() {
        view.addSubview(logoImageView)
    }
    
    override func layout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func configure() {
        view.backgroundColor = TDColor.Primary.primary50
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .validateVersion(let policy):
                    self?.handleVersionPolicy(policy: policy)
                case .failure(let errorMessage):
                    self?.showErrorAlert(errorMessage: errorMessage)
                }
            }.store(in: &cancellables)
    }
    
    private func handleVersionPolicy(policy: VersionPolicy) {
        switch policy {
        case .force:
            showOneButtonAlert(
                title: "업데이트가 필요해요",
                message: "새로운 기능을 위해 업데이트가 필요해요 !",
                confirmTitle: "업데이트") {
                    UIApplication.shared.open(Constant.appStoreURL, options: [:], completionHandler: nil)
                }
            
        case .recommended:
            showCommonAlert(
                title: "토덕의 새로운 업데이트 버전이있어요 !",
                message: "새로운 기능을 사용할 수 있어요 !",
                cancelTitle: "다음에 하기",
                confirmTitle: "업데이트") { [weak self] in
                    self?.coordinator?.finish(by: .popNotAnimated)
                } onConfirm: {
                    UIApplication.shared.open(Constant.appStoreURL, options: [:], completionHandler: nil)
                }
        case .none:
            coordinator?.finish(by: .popNotAnimated)
        }
    }
}
