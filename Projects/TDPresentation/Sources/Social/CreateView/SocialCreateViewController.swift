import Combine
import TDDesign
import UIKit

final class SocialCreateViewController: BaseViewController<SocialCreateView> {
    
    weak var coordinator: SocialCreateCoordinator?
    
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
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        layoutView.socialAddPhotoView.delegate = self
        navigationItem.rightBarButtonItem = registerButton
        layoutView.socialSelectCategoryView.categorySelectView.chipDelegate = self
        layoutView.socialSelectCategoryView.categorySelectView.setChips(viewModel.chips)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .success:
                    self.coordinator?.didCreateSocial()
                case .setImage:
                    self.layoutView.socialAddPhotoView.addPhotos(self.viewModel.images)
                case .notSelectCategory:
                    break
                case .failure(_):
                    break
                }
            }
            .store(in: &cancellables)
    }

}

extension SocialCreateViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDDesign.TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        input.send(.chipSelect(at: index))
    }
}

extension SocialCreateViewController: SocialAddPhotoViewDelegate, TDPhotoPickerDelegate {
    func didSelectPhotos(_ picker: TDDesign.TDPhotoPickerController, photos: [Data]) {
        input.send(.setImages(photos))
    }
    
    func deniedPhotoAccess(_ picker: TDDesign.TDPhotoPickerController) {
        // TODO: 권한 없을때 ? ALERT 필요
        return
    }
    
    func didTapAddPhotoButton(_ view: SocialAddPhotoView?) {
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: 5)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }
}

extension SocialCreateViewController {
    private func didTapRegisterButton() {
        // TODO: - 등록 버튼 클릭
    }
}
