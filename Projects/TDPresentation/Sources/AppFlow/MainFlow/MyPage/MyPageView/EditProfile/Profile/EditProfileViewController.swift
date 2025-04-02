import UIKit
import TDDesign
import Combine

final class EditProfileViewController: BaseViewController<EditProfileView> {
    private let viewModel: EditProfileViewModel
    private let input = PassthroughSubject<EditProfileViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: EditProfileCoordinator?
    
    // MARK: - Initialize
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Common Methods
    override func configure() {
        layoutView.delegate = self
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "프로필 수정",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            },
            rightButtonTitle: "저장",
            rightButtonAction: UIAction { [weak self] _ in
                self?.input.send(.updateNickname)
            }
        )
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .updatedNickname:
                    self?.coordinator?.finish(by: .pop)
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
}

extension EditProfileViewController: EditProfileDelegate {
    func editProfileView(
        _ view: EditProfileView,
        text: String,
        didUpdateCondition isConditionMet: Bool
    ) {
        input.send(.writeNickname(nickname: text))
        if isConditionMet {
            navigationController?.updateRightButtonState(to: .normal)
        } else {
            navigationController?.updateRightButtonState(to: .disabled)
        }
    }
}
