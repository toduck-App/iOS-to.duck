import Combine
import Kingfisher
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
    var post: Post? = nil

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

    override func viewDidLoad() {
        super.viewDidLoad()
        if let post {
            editPost(post)
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

    func editPost(_ post: Post) {
        if let category = post.category {
            layoutView.socialSelectCategoryView.categorySelectView.setSelectChips(chips, selectChipIndexs: category.map { $0.rawValue - 1 })
            for category in category {
                input.send(.chipSelect(at: category.rawValue - 1))
            }
        }

        if let title = post.titleText {
            layoutView.titleTextFieldView.setupTextField(title)
            input.send(.setTitle(title))
        }
        if !post.contentText.isEmpty {
            layoutView.descriptionTextFieldView.setupTextView(text: post.contentText)
            input.send(.setContent(post.contentText))
        }

        if let urlStrings = post.imageList, !urlStrings.isEmpty {
            let urls = urlStrings
                .compactMap { URL(string: $0) }
            var imageDatas: [Data] = []
            let group = DispatchGroup()

            for url in urls {
                group.enter()
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    defer { group.leave() }
                    switch result {
                    case .success(let value):
                        if let data = value.image.jpegData(compressionQuality: 1.0) {
                            imageDatas.append(data)
                        }
                    case .failure(let error):
                        print("이미지 로드 실패:", error)
                    }
                }
            }

            group.notify(queue: .main) { [weak self] in
                guard let self else { return }
                input.send(.setImages(imageDatas, false))
                layoutView.formPhotoView.addPhotos(imageDatas)
            }
        }
        if let routine = post.routine {
            layoutView.socialSelectRoutineView.setRoutine(string: routine.title)
            input.send(.setRoutine(routine))
        }
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
        input.send(.setImages(photos, true))
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
        if viewModel.canCreatePost { hideSnackBar(); return }
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
