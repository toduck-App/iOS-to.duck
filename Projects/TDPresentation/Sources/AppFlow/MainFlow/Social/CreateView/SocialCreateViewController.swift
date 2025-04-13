import Combine
import TDDesign
import TDDomain
import UIKit

final class SocialCreateViewController: BaseViewController<SocialCreateView> {
    weak var coordinator: SocialCreateCoordinator?

    private(set) var chips: [TDChipItem] = PostCategory.allCases.map { TDChipItem(title: $0.title) }

    private let input = PassthroughSubject<SocialCreateViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var isAtBottom = false
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            coordinator?.finish(by: .pop)
        }
    }

    override func configure() {
        layoutView.formPhotoView.delegate = self
        layoutView.socialSelectRoutineView.delegate = self
        layoutView.titleTextFieldView.delegate = self
        layoutView.descriptionTextFieldView.delegate = self
        layoutView.socialSelectCategoryView.categorySelectView.chipDelegate = self
        layoutView.socialSelectCategoryView.categorySelectView.setChips(chips)
        layoutView.scrollView.delegate = self
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            self?.didTapRegisterButton()
        }, for: .touchUpInside)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .createPost:
                    coordinator?.finish(by: .pop)
                case .setRoutine:
                    layoutView.socialSelectRoutineView.setRoutine(string: viewModel.selectedRoutine?.title ?? "")
                case .setImage:
                    layoutView.formPhotoView.addPhotos(viewModel.images)
                case .failure(let message):
                    showErrorAlert(errorMessage: message)
                case .success:
                    coordinator?.didTapDoneButton()
                case .canCreatePost(let isEnabled):
                    layoutView.saveButton.isEnabled = isEnabled
                }
            }
            .store(in: &cancellables)
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
        showErrorAlert(errorMessage: "사진 접근 권한이 없습니다.")
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
        input.send(.setTitle(text))
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
        input.send(.createPost)
    }
}

// MARK: - UIScrollViewDelegate

extension SocialCreateViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY + height >= contentHeight - 10 {
            showSnackBar()
        } else {
            hideSnackBar()
        }
    }
    
    private func showSnackBar() {
        guard let constraint = layoutView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: -20)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func hideSnackBar() {
        guard let constraint = layoutView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: 50)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
