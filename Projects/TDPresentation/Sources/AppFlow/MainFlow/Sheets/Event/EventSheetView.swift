import Kingfisher
import SnapKit
import TDDesign
import Then
import UIKit

protocol EventSheetViewDelegate: AnyObject {
    func eventSheetDidTapViewDetails(_ view: EventSheetView)
    func eventSheetDidTapHideToday(_ view: EventSheetView)
    func eventSheetDidTapClose(_ view: EventSheetView)
}

final class EventSheetView: BaseView {
    // MARK: - Public

    weak var delegate: EventSheetViewDelegate?

    // MARK: - UI Components

    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private let imageContainer = UIView()

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.isAccessibilityElement = true
    }

    private lazy var detailsButton = TDBaseButton(
        title: "이벤트 내용 보기",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader3.font
    ).then {
        $0.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.eventSheetDidTapViewDetails(self)
        }, for: .touchUpInside)
    }

    private let bottomContainer = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 0
        $0.layer.borderWidth = 1 / UIScreen.main.scale
        $0.layer.borderColor = TDColor.Neutral.neutral400.cgColor
    }

    private let bottomStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 1
        $0.backgroundColor = TDColor.Neutral.neutral400
    }

    private lazy var hideTodayButton = TDBaseButton(
        title: "오늘 그만 보기",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral500,
        font: TDFont.boldHeader3.font,
        radius: 0
    ).then {
        $0.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.eventSheetDidTapHideToday(self)
        }, for: .touchUpInside)
    }

    private lazy var closeButton = TDBaseButton(
        title: "닫기",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        font: TDFont.boldHeader3.font,
        radius: 0
    ).then {
        $0.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.eventSheetDidTapClose(self)
        }, for: .touchUpInside)
    }

    private var imageAspectConstraint: Constraint?

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - BaseView Hooks

    override func addview() {
        addSubview(vStack)
        vStack.addArrangedSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(detailsButton)

        vStack.addArrangedSubview(bottomContainer)
        bottomContainer.addSubview(bottomStack)
        bottomStack.addArrangedSubview(hideTodayButton)
        bottomStack.addArrangedSubview(closeButton)
    }

    override func layout() {
        vStack.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageContainer.snp.makeConstraints { make in
            make.height.equalTo(imageContainer.snp.width).multipliedBy(9.0 / 16.0).priority(750)
        }

        detailsButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageContainer.snp.centerX)
            make.horizontalEdges.equalToSuperview().inset(18)
            make.bottom.equalTo(imageContainer.snp.bottom).inset(20)
        }

        bottomContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(64)
        }

        bottomStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(
        thumbnailURL: URL?
    ) {
        if let url = thumbnailURL {
            imageView.kf.setImage(with: url) { [weak self] result in
                guard let self else { return }
                if case let .success(value) = result {
                    let size = value.image.size
                    updateImageAspect(heightToWidth: size.height / size.width)
                }
            }
        }
    }

    func configure(
        image: UIImage
    ) {
        imageView.image = image
        let size = image.size
        updateImageAspect(heightToWidth: size.height / size.width)
    }

    private func updateImageAspect(heightToWidth: CGFloat) {
        // 이미지 원본 비율로 컨테이너 높이 갱신
        imageContainer.snp.remakeConstraints { make in
            make.height.equalTo(imageContainer.snp.width).multipliedBy(heightToWidth).priority(900)
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
