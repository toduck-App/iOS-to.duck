import UIKit
import TDDomain
import Combine
import TDDesign
import TDCore

final class DiaryMakorViewController: BaseViewController<DiaryMakorView> {
    // MARK: - Properties
    private let viewModel: DiaryMakorViewModel
    private let isEdit: Bool
    private let input = PassthroughSubject<DiaryMakorViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var isMoodSelected = false
    weak var coordinator: DiaryMakorCoordinator?
    
    // MARK: - Initializer
    init(
        viewModel: DiaryMakorViewModel,
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
extension DiaryMakorViewController: UIScrollViewDelegate {
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
extension DiaryMakorViewController: DiaryMoodCollectionViewDelegate {
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
extension DiaryMakorViewController: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String) {
        if textField == layoutView.titleForm {
            input.send(.updateTitleTextField(text))
        }
    }
}

// MARK: - TextViewDelegate
extension DiaryMakorViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String) {
        input.send(.updateMemoTextView(text))
    }
}

// MARK: - SocialAddPhotoViewDelegate
extension DiaryMakorViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
    func didSelectPhotos(_ picker: TDPhotoPickerController, photos: [Data]) {
        input.send(.setImages(photos))
    }

    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        showErrorAlert(errorMessage: "사진 접근 권한이 없습니다.")
    }

    func didTapAddPhotoButton(_ view: TDFormPhotoView?) {
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: 2)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }
}
