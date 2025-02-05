import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialCreateViewController: BaseViewController<SocialCreateView> {
    weak var coordinator: SocialCreateCoordinator?

    private(set) var chips: [TDChipItem] = PostCategory.allCases.map { TDChipItem(title: $0.rawValue) }
    private lazy var registerButton = UIBarButtonItem(
        title: "등록",
        primaryAction: UIAction {
            [weak self] _ in
            self?.didTapRegisterButton()
        }).then {
        $0.tintColor = TDColor.Primary.primary500
    }

    private let input = PassthroughSubject<SocialCreateViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    let viewModel: SocialCreateViewModel!

    init(viewModel: SocialCreateViewModel) {
        self.viewModel = viewModel
        super.init()
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        layoutView.formPhotoView.delegate = self
        layoutView.socialSelectRoutineView.delegate = self
        layoutView.titleTextFieldView.delegate = self
        layoutView.descriptionTextFieldView.delegate = self
        navigationItem.rightBarButtonItem = registerButton
        layoutView.socialSelectCategoryView.categorySelectView.chipDelegate = self
        layoutView.socialSelectCategoryView.categorySelectView.setChips(chips)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .createPost:
                    coordinator?.didTapDoneButton()
                case .setRoutine:
                    layoutView.socialSelectRoutineView.setRoutine(string: viewModel.selectedRoutine?.title ?? "")
                case .setImage:
                    layoutView.formPhotoView.addPhotos(viewModel.images)
                case .failure:
                    break
                }
                updateNavigationBar()
            }
            .store(in: &cancellables)
    }

    private func updateNavigationBar() {
        let isEnabled = viewModel.selectedCategory != nil && !viewModel.title.isEmpty && !viewModel.content.isEmpty
        registerButton.isEnabled = isEnabled
    }
}

// MARK: - SocialSelectRoutineViewDelegate

extension SocialCreateViewController: SocialRoutineInputDelegate {
    func setRoutine(_ routine: Routine) {
        input.send(.setRoutine(routine))
    }

    func didTapRoutineInputView(_ view: SocialRoutineInputView?) {
        coordinator?.didTapSelectRoutineButton()
    }
}

// MARK: - TDChipCollectionViewDelegate

extension SocialCreateViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDDesign.TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        input.send(.chipSelect(at: index))
    }
}

// MARK: - SocialAddPhotoViewDelegate

extension SocialCreateViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
    func didSelectPhotos(_ picker: TDDesign.TDPhotoPickerController, photos: [Data]) {
        input.send(.setImages(photos))
    }

    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        // TODO: 권한 없을때 ? ALERT 필요
    }

    func didTapAddPhotoButton(_ view: TDFormPhotoView?) {
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: 5)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }
}

// MARK: - TextFieldDelegate

extension SocialCreateViewController: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDDesign.TDFormTextField, didChangeText text: String) {
        input.send(.setContent(text))
    }
}

// MARK: - TextViewDelegate

extension SocialCreateViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDDesign.TDFormTextView, didChangeText text: String) {
        input.send(.setContent(text))
    }
}

// MARK: - Create Action

extension SocialCreateViewController {
    private func didTapRegisterButton() {
        // TODO: - 등록 버튼 클릭
    }
}
