import UIKit
import TDDomain
import Combine
import TDDesign
import TDCore
import FittedSheets

final class SimpleDiaryViewController: BaseViewController<SimpleDiaryView> {
    // MARK: - Properties
    private let viewModel: SimpleDiaryViewModel
    private let isEdit: Bool
    private let input = PassthroughSubject<SimpleDiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var isMoodSelected = false
    weak var coordinator: SimpleDiaryCoordinator?
    
    // MARK: - Initializer
    init(
        viewModel: SimpleDiaryViewModel,
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
                    self?.coordinator?.completeAndPopViewController()
                case .failure(let message):
                    self?.layoutView.saveButton.isEnabled = true
                    self?.showErrorAlert(errorMessage: message)
                case .updateKeywords(let keywords):
                    self?.updateKeywordTags(keywords: keywords)
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
        // keywordTagListView.delegate는 삭제 모드 진입 시에만 설정
        
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            if self?.isEdit == true {
                self?.input.send(.tapEditButton)
                
            } else {
                self?.input.send(.tapSaveButton)
            }
            self?.layoutView.saveButton.isEnabled = false
        }, for: .touchUpInside)
        
        layoutView.keywordAddButton.addAction(UIAction { [weak self] _ in
            self?.showKeywordSelectionSheet()
        }, for: .touchUpInside)
        
        // 헤더 삭제 버튼 액션
        layoutView.keywordHeaderDeleteButton.addAction(UIAction { [weak self] _ in
            self?.enterDeleteMode()
        }, for: .touchUpInside)
        
        // 삭제 모드의 삭제 버튼 액션
        layoutView.diaryKeywordDeleteButton.addAction(UIAction { [weak self] _ in
            self?.deleteSelectedKeywords()
        }, for: .touchUpInside)
        
        layoutView.diaryKeywordCancelButton.addAction(UIAction { [weak self] _ in
            self?.exitDeleteMode()
        }, for: .touchUpInside)
    }
    
    func updateEditView(preDiary: Diary) {
        layoutView.diaryMoodCollectionView.setupSelectedMoodImage(preDiary.emotion.image)
        layoutView.saveButton.isEnabled = true
        layoutView.saveButton.layer.borderWidth = 0
        layoutView.titleForm.setupTextField(preDiary.title)
        layoutView.noticeSnackBarView.isHidden = true
        layoutView.recordTextView.setupTextView(text: preDiary.memo)

        let keywordNames = preDiary.diaryKeywords.map { $0.keywordName }
        let keywordIds = preDiary.diaryKeywords.map { $0.id }
        layoutView.updateKeywordTags(keywords: keywordNames, keywordIds: keywordIds)
    }
    
    // MARK: - Keyword Methods
    private func showKeywordSelectionSheet() {

        guard let injector = self.coordinator?.injector else {
            return
        }
        let fetchDiaryKeywordsUseCase = injector.resolve(FetchDiaryKeywordUseCase.self)
        let createDiaryKeywordUseCase = injector.resolve(CreateDiaryKeywordUseCase.self)
        let deleteDiaryKeywordUseCase = injector.resolve(DeleteDiaryKeywordUseCase.self)
        
        let keywordViewModel = DiaryKeywordViewModel(
            selectedMood: nil,
            selectedDate: nil,
            fetchDiaryKeywordsUseCase: fetchDiaryKeywordsUseCase,
            createDiaryKeywordUseCase: createDiaryKeywordUseCase,
            deleteDiaryKeywordUseCase: deleteDiaryKeywordUseCase
        )
        
        
        let keywordViewController = DiaryKeywordViewController(viewModel: keywordViewModel, viewType: .sheet)
        keywordViewController.onKeywordsSelected = { [weak self] keywords in
            self?.input.send(.updateSelectedKeywords(keywords))
        }
        
        let sheetController = SheetViewController(
            controller: keywordViewController,
            sizes: [.fixed(560)],
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        sheetController.cornerRadius = 28
        
        present(sheetController, animated: true)
    }
    
    private func enterDeleteMode() {
        layoutView.isDeleteMode = true
        layoutView.updateDeleteModeUI()
        // 삭제 모드 진입 시 키워드 선택 가능하도록 설정
        layoutView.keywordTagListView.delegate = self
    }
    
    private func exitDeleteMode() {
        layoutView.isDeleteMode = false
        layoutView.selectedKeywordsForDeletion.removeAll()
        layoutView.updateDeleteModeUI()
        // 삭제 모드 종료 시 delegate 제거
        layoutView.keywordTagListView.delegate = nil
    }
    
    private func deleteSelectedKeywords() {
        let idsToDelete = layoutView.selectedKeywordsForDeletion
        let keywordsToDelete = viewModel.selectedKeywords.filter { idsToDelete.contains($0.id) }

        guard !keywordsToDelete.isEmpty else { return }

        input.send(.deleteSelectedKeywords(keywordsToDelete))
        exitDeleteMode()
    }
    
    private func updateKeywordTags(keywords: [UserKeyword]) {
        let keywordNames = keywords.map { $0.name }
        let keywordIds = keywords.map { $0.id }
        layoutView.updateKeywordTags(keywords: keywordNames, keywordIds: keywordIds)
        
        if layoutView.isDeleteMode {
            layoutView.keywordTagListView.updateSelectedKeywords(layoutView.selectedKeywordsForDeletion)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SimpleDiaryViewController: UIScrollViewDelegate {
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
extension SimpleDiaryViewController: DiaryMoodCollectionViewDelegate {
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
extension SimpleDiaryViewController: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String) {
        if textField == layoutView.titleForm {
            input.send(.updateTitleTextField(text))
        }
    }
}

// MARK: - TextViewDelegate
extension SimpleDiaryViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String) {
        input.send(.updateMemoTextView(text))
    }
}

// MARK: - TodayKeywordTagListViewDelegate
extension SimpleDiaryViewController: TodayKeywordTagListViewDelegate {
    func didSelectKeyword(at id: Int) {
        guard layoutView.isDeleteMode else { return }
        
        if layoutView.selectedKeywordsForDeletion.contains(id) {
            layoutView.selectedKeywordsForDeletion.remove(id)
        } else {
            layoutView.selectedKeywordsForDeletion.insert(id)
        }
        
        layoutView.keywordTagListView.updateSelectedKeywords(layoutView.selectedKeywordsForDeletion)
    }
}

// MARK: - SocialAddPhotoViewDelegate
extension SimpleDiaryViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
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
