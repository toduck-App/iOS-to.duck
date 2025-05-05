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
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.updateProfile)
        }, for: .touchUpInside)
        layoutView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage)))
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "프로필 수정",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .updatedProfile:
                    self?.coordinator?.finish(by: .pop)
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    func updateNickName(nickName: String) {
        layoutView.nicknameField.setupTextField(nickName)
    }
}

extension EditProfileViewController: EditProfileDelegate, TDPhotoPickerDelegate {
    func editProfileView(
        _ view: EditProfileView,
        text: String,
        didUpdateCondition isConditionMet: Bool
    ) {
        input.send(.writeNickname(nickname: text))
        layoutView.saveButton.isEnabled = isConditionMet
    }
    
    @objc
    func didTapProfileImage() {
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: 1)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }
    
    func didSelectPhotos(_ picker: TDDesign.TDPhotoPickerController, photos: [Data]) {
        input.send(.writeProfileImage(image: photos[0]))
        layoutView.configureImageView(imageData: photos[0])
        layoutView.saveButton.isEnabled = true
    }
    
    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        self.showErrorAlert(errorMessage: "사진 접근 권한이 필요합니다.")
    }
}
