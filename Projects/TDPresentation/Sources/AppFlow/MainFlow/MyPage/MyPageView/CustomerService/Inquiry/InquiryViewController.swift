import Combine
import TDDesign
import UIKit

final class InquiryViewController: BaseViewController<InquiryView> {
    weak var coordinator: InquiryCoordinator?

    private let viewModel: InquiryViewModel
    private let input = PassthroughSubject<InquiryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let chips: [TDChipItem] = InquiryViewModel.InquiryType.allCases.map {
        TDChipItem(title: $0.rawValue)
    }

    // MARK: - Init

    init(viewModel: InquiryViewModel) {
        self.viewModel = viewModel
        super.init()
        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func configure() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "",
            leftButtonAction: UIAction(handler: { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            })
        )

        layoutView.inquiryTypeView.chipCollectionView.chipDelegate = self
        layoutView.inquiryTypeView.chipCollectionView.setChips(chips)
        layoutView.contentTextView.delegate = self
        layoutView.formPhotoView.delegate = self
        layoutView.scrollView.delegate = self

        layoutView.submitButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.submitInquiry)
        }, for: .touchUpInside)
    }

    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .canSubmit(let isEnabled):
                    layoutView.submitButton.isEnabled = isEnabled
                case .setImage:
                    layoutView.formPhotoView.addPhotos(viewModel.images)
                case .failure(let message):
                    showErrorAlert(errorMessage: message)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - TDChipCollectionViewDelegate

extension InquiryViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(
        _ collectionView: TDChipCollectionView,
        didSelectChipAt index: Int,
        chipText: String
    ) {
        input.send(.chipSelect(at: index))
        layoutView.inquiryTypeView.setTypeSelected(true)
    }
}

// MARK: - TDFormTextViewDelegate

extension InquiryViewController: TDFormTextViewDelegate {
    func tdTextView(_ textView: TDFormTextView, didChangeText text: String) {
        input.send(.setContent(text))
    }
}

// MARK: - TDFormPhotoDelegate, TDPhotoPickerDelegate

extension InquiryViewController: TDFormPhotoDelegate, TDPhotoPickerDelegate {
    func didTapAddPhotoButton(_ view: TDFormPhotoView?) {
        let photoPickerController = TDPhotoPickerController(maximumSelectablePhotos: 5)
        photoPickerController.pickerDelegate = self
        navigationController?.pushTDViewController(photoPickerController, animated: true)
    }

    func didSelectPhotos(_ picker: TDPhotoPickerController, photos: [Data]) {
        input.send(.setImages(photos))
    }

    func deniedPhotoAccess(_ picker: TDPhotoPickerController) {
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

// MARK: - UIScrollViewDelegate

extension InquiryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.canSubmit {
            hideSnackBar()
            return
        }
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
