import Photos
import SnapKit
import Then
import UIKit

public protocol TDPhotoPickerDelegate: AnyObject {
    func didSelectPhotos(_ picker: TDPhotoPickerController, photos: [Data])
    func deniedPhotoAccess(_ picker: TDPhotoPickerController)
}

public final class TDPhotoPickerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Properties

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.width
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 10
        $0.itemSize = CGSize(width: (width - 2) / 3, height: (width - 2) / 3)
        $0.minimumInteritemSpacing = 1
        $0.minimumLineSpacing = 1
    }).then {
        $0.backgroundColor = TDColor.baseWhite
    }

    private lazy var doneButton = UIBarButtonItem(
        title: "완료",
        primaryAction: UIAction {
            [weak self] _ in
            self?.didTapDoneButton()
        }
    ).then {
        $0.tintColor = TDColor.Primary.primary500
    }

    // MARK: - Properties

    public weak var pickerDelegate: TDPhotoPickerDelegate?
    private let maximumSelectablePhotos: Int
    private var photos: [PHAsset] = []
    private var selectedPhotos: Set<PHAsset> = []

    // MARK: - Initializer

    public init(maximumSelectablePhotos: Int) {
        self.maximumSelectablePhotos = maximumSelectablePhotos
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = TDColor.baseWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoPickerCell.self, forCellWithReuseIdentifier: PhotoPickerCell.identifier)
        collectionView.register(CameraCell.self, forCellWithReuseIdentifier: CameraCell.identifier)

        updateNavigationBar()
        setupLayout()
        checkPhotoLibraryPermission()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Update Navigation Bar

    private func updateNavigationBar() {
        navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = !selectedPhotos.isEmpty
        title = "사진선택 (\(selectedPhotos.count) / \(maximumSelectablePhotos))"
    }

    // MARK: - Photo Library Permission

    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            fetchPhotos()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                if newStatus == .authorized {
                    self?.fetchPhotos()
                }
            }
        default:
            pickerDelegate?.deniedPhotoAccess(self)
        }
    }

    // MARK: - Fetch Photos

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        assets.enumerateObjects { [weak self] asset, _, _ in
            self?.photos.append(asset)
        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - Actions

    private func didTapDoneButton() {
        let selectedPhotoData: [Data] = selectedPhotos.compactMap { asset in
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            var imageData: Data?
            manager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
                imageData = data
            }
            return imageData
        }
        pickerDelegate?.didSelectPhotos(self, photos: selectedPhotoData)
        navigationController?.popViewController(animated: true)
    }

    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(
            editedImage,
            self,
            #selector(imageSavedCallback(_:didFinishSavingWithError:contextInfo:)),
            nil
        )

        picker.dismiss(animated: true)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Saved Photo Callback

    @objc private func imageSavedCallback(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("사진 저장 실패: \(error.localizedDescription)")
            return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let latestAsset = fetchResult.firstObject else {
            return
        }

        photos.insert(latestAsset, at: 0)
        guard selectedPhotos.count < maximumSelectablePhotos else { return }
        selectedPhotos.insert(latestAsset)
        let newIndexPath = IndexPath(item: 1, section: 0)
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [newIndexPath])
        } completion: { _ in
            self.collectionView.reloadItems(at: [newIndexPath])
        }
        updateNavigationBar()
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 첫 번째 셀은 카메라용 셀이므로 +1
        return photos.count + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            // 카메라 버튼 셀
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraCell.identifier, for: indexPath) as? CameraCell else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            // 포토 셀
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPickerCell.identifier, for: indexPath) as? PhotoPickerCell else {
                return UICollectionViewCell()
            }
            let asset = photos[indexPath.item - 1]
            cell.configure(with: asset, isSelected: selectedPhotos.contains(asset))
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // 카메라 셀 선택 시
            presentCamera()
        } else {
            let asset = photos[indexPath.item - 1]
            if selectedPhotos.contains(asset) {
                selectedPhotos.remove(asset)
            } else {
                if selectedPhotos.count >= maximumSelectablePhotos {
                    return
                }
                selectedPhotos.insert(asset)
            }
            updateNavigationBar()
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - CameraCell

final class CameraCell: UICollectionViewCell {
    private let cameraIcon = UIImageView().then {
        $0.image = TDImage.cameraMedium.withRenderingMode(.alwaysTemplate)
        $0.tintColor = TDColor.Neutral.neutral600
        $0.contentMode = .scaleAspectFit
    }

    private let cameraLabel = TDLabel(
        labelText: "사진찍기",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral600
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = TDColor.baseWhite
        contentView.addSubview(cameraIcon)
        contentView.addSubview(cameraLabel)

        cameraIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-8)
            $0.width.height.equalTo(36)
        }

        cameraLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cameraIcon.snp.bottom).offset(8)
        }
    }
}

// MARK: - PhotoPickerCell

final class PhotoPickerCell: UICollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let checkmarkView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 2
        $0.layer.borderColor = TDColor.baseWhite.cgColor
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
    }

    private let checkImageView = UIImageView().then {
        $0.image = TDImage.checkMedium.withRenderingMode(.alwaysTemplate)
        $0.tintColor = TDColor.baseWhite
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with asset: PHAsset, isSelected: Bool) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.isSynchronous = true
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            self?.imageView.image = image
        }

        checkImageView.isHidden = !isSelected
        checkImageView.backgroundColor = isSelected ? TDColor.Primary.primary500 : .clear
    }

    private func setupLayout() {
        backgroundColor = TDColor.baseWhite
        contentView.addSubview(imageView)
        contentView.addSubview(checkmarkView)
        checkmarkView.addSubview(checkImageView)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        checkmarkView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.trailing.equalToSuperview().inset(5)
        }

        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}
