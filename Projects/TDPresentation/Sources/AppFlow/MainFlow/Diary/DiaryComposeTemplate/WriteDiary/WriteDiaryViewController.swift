import UIKit
import TDDomain
import Combine
import TDDesign

final class WriteDiaryViewController: BaseViewController<WriteDiaryView> {
    
    // MARK: - UI Components
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "3 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    private let viewModel: WriteDiaryViewModel
    private let input = PassthroughSubject<WriteDiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: WriteDiaryCoordinator?
    
    // MARK: - Initializer
    
    init(viewModel: WriteDiaryViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        configurePagingNavigationBar(currentPage: 3, totalPages: 3)
        layoutView.formPhotoView.delegate = self
        layoutView.recordTextView.delegate = self
        layoutView.saveButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.createDiary)
            self?.layoutView.saveButton.isEnabled = false
        }, for: .touchUpInside)
    }
    
    override func binding() {
        super.binding()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .setImage:
                    layoutView.formPhotoView.addPhotos(viewModel.images)
                case .enableSaveButton(let isEnabled):
                    layoutView.saveButton.isEnabled = isEnabled
                case .failure(let message):
                    layoutView.saveButton.isEnabled = true
                    showErrorAlert(errorMessage: message)
                case .success:
                    // TODO: 다이어리 작성 성공 화면으로 이동
                    print("다이어리 작성 성공")
                }
            }.store(in: &cancellables)
    }
}

extension WriteDiaryViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
    func didTapAddPhotoButton(_ view: TDFormPhotoView?) {
        let photoPickerController = TDPhotoPickerController(
            maximumSelectablePhotos: 2
        )
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(
            photoPickerController,
            animated: true
        )
    }
    
    func didSelectPhotos(
        _ picker: TDDesign.TDPhotoPickerController,
        photos: [Data]
    ) {
        input.send(.setImages(photos))
    }

    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        showCommonAlert(
            title: "카메라 사용에 대한 접근 권한이 없어요",
            message: "[앱 설정 → 앱 이름] 탭에서 접근을 활성화 해주세요",
            image: TDImage.Alert.permissionCamera,
            cancelTitle: "취소",
            confirmTitle: "설정으로 이동",
            onConfirm: {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!
                )
            }
        )
    }
}
// MARK: - TextViewDelegate

extension WriteDiaryViewController: TDFormTextViewDelegate {
    func tdTextView(
        _ textView: TDDesign.TDFormTextView,
        didChangeText text: String
    ) {
        input.send(.setContent(text))
    }
}

// MARK: - PagingNavigationBarConfigurable

extension WriteDiaryViewController: PagingNavigationBarConfigurable { }
