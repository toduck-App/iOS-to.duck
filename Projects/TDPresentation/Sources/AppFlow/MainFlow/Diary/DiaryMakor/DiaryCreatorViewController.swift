import UIKit
import TDDomain
import Combine
import TDDesign
import TDCore

final class DiaryCreatorViewController: BaseViewController<DiaryCreatorView> {
    // MARK: - Properties
    private let viewModel: DiaryCreatorViewModel
    private let isEdit: Bool
    private let input = PassthroughSubject<DiaryCreatorViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var isMoodSelected = false
    weak var coordinator: DiaryCreatorCoordinator?
    
    // MARK: - Initializer
    init(
        viewModel: DiaryCreatorViewModel,
        isEdit: Bool
    ) {
        self.viewModel = viewModel
        self.isEdit = isEdit
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Common Methods
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .setImage:
                    self?.layoutView.formPhotoView.addPhotos(self?.viewModel.images ?? [])
                case .savedDiary:
                    self?.coordinator?.finish(by: .pop)
                case .failure(let message):
                    self?.layoutView.saveButton.isEnabled = true
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        layoutView.isEdit = isEdit
        layoutView.scrollView.delegate = self
        layoutView.titleForm.delegate = self
        layoutView.formPhotoView.delegate = self
        layoutView.recordTextView.delegate = self
        layoutView.diaryMoodCollectionView.delegate = self
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            if self?.isEdit == true {
                self?.input.send(.tapEditButton)
                
            } else {
                self?.input.send(.tapSaveButton)
            }
            self?.layoutView.saveButton.isEnabled = false
        }, for: .touchUpInside)
    }
    
    func updateEditView(preDiary: Diary) {
        layoutView.diaryMoodCollectionView.setupSelectedMoodImage(preDiary.emotion.image)
        layoutView.saveButton.isEnabled = true
        layoutView.saveButton.layer.borderWidth = 0
        layoutView.titleForm.setupTextField(preDiary.title)
        layoutView.noticeSnackBarView.isHidden = true
        layoutView.recordTextView.setupTextView(text: preDiary.memo)
    }
}

// MARK: - UIScrollViewDelegate
extension DiaryCreatorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY + height >= contentHeight - 10 {
            if !isMoodSelected {
                showSnackBar()
            }
        } else {
            hideSnackBar()
        }
    }
    
    private func showSnackBar() {
        guard let constraint = layoutView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideSnackBar() {
        guard let constraint = layoutView.noticeSnackBarBottomConstraint else { return }
        constraint.update(offset: 50)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - DiaryMoodCollectionViewDelegate
extension DiaryCreatorViewController: DiaryMoodCollectionViewDelegate {
    func didTapCategoryCell(
        _ diaryMoodCollectionView: TDDesign.DiaryMoodCollectionView,
        selectedMood: UIImage
    ) {
        isMoodSelected = true
        layoutView.saveButton.isEnabled = true
        layoutView.saveButton.layer.borderWidth = 0
        input.send(.tapCategoryCell(UIImage.reverseMoodDictionary[selectedMood] ?? "HAPPY"))
    }
}

// MARK: - TextFieldDelegate
extension DiaryCreatorViewController: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String) {
        if textField == layoutView.titleForm {
            input.send(.updateTitleTextField(text))
        }
    }
}

// MARK: - TextViewDelegate
extension DiaryCreatorViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String) {
        input.send(.updateMemoTextView(text))
    }
}

// MARK: - SocialAddPhotoViewDelegate
extension DiaryCreatorViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
    func didSelectPhotos(_ picker: TDPhotoPickerController, photos: [Data]) {
        input.send(.setImages(photos))
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

    func didTapAddPhotoButton(_ view: TDFormPhotoView?) {
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: 2)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }
}
