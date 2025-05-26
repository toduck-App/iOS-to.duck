import UIKit
import TDDesign
import Combine
import Kingfisher

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
            guard self?.layoutView.nicknameField.text.count ?? 0 >= 2 else { return }
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
                case .failureNickname(let message):
                    self?.showErrorAlert(titleError: "죄송해요 !", errorMessage: message)
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    func updateNickName(nickName: String) {
        layoutView.nicknameField.setupTextField(nickName)
    }
    
    func updateProfileImage(imageUrl: String?) {
        guard let imageUrl, let url = URL(string: imageUrl) else {
            layoutView.configureImageViewWithDefaultImage()
            return
        }
        
        layoutView.profileImageView.innerImageView.kf.setImage(
            with: url,
            placeholder: TDImage.Profile.medium,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}

extension EditProfileViewController: EditProfileDelegate, TDPhotoPickerDelegate {
    func editProfileView(
        _ view: EditProfileView,
        text: String,
        didUpdateCondition isConditionMet: Bool
    ) {
        input.send(.writeNickname(nickname: text))
        if layoutView.nicknameField.text.count < 2 {
            layoutView.saveButton.isEnabled = false
        } else {
            layoutView.saveButton.isEnabled = true
        }
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
        showCommonAlert(
            title: "카메라 사용에 대한 접근 권한이 없어요",
            message: "[앱 설정 → 앱 이름] 탭에서 접근을 활성화 해주세요",
            image: TDImage.Alert.permissionCamera,
            cancelTitle: "취소",
            confirmTitle: "설정으로 이동", onConfirm: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        )
    }
}
