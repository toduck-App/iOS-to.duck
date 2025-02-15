import SnapKit
import Then
import UIKit

public enum TDFormMoveViewType {
    case category
    case date
    case time
    case cycle
    case location
}

public protocol TDFormMoveViewDelegate: AnyObject {
    func didTapMoveView(_ view: TDFormMoveView, type: TDFormMoveViewType)
}

public final class TDFormMoveView: UIView {
    // MARK: - UI Properties
    private let containerHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    // Title
    private let titleHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private var titleImageView: UIImageView?
    private let titleLabel = TDRequiredTitle()
    
    // Description
    private let descriptionHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let descriptionLabel = TDLabel(
        toduckFont: .mediumBody1,
        alignment: .right
    ).then {
        $0.textAlignment = .right
        $0.textColor = TDColor.Neutral.neutral600
    }
    private let descriptionImageView = UIImageView().then {
        $0.image = TDImage.Direction.right2Medium.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = TDColor.Neutral.neutral600
    }
    
    // MARK: - Properties
    private let type: TDFormMoveViewType
    private let isRequired: Bool
    private let isReadOnlyMode: Bool
    public weak var delegate: TDFormMoveViewDelegate?
    
    /// - Parameters:
    ///  - type: TDFormMoveViewType
    ///  - isRequired: 필수 여부
    ///  - isEditMode: 일정 추가&수정 혹은 읽기 전용 모드
    // MARK: - Initializer
    public init(
        type: TDFormMoveViewType,
        isRequired: Bool,
        isReadOnlyMode: Bool = false
    ) {
        self.type = type
        self.isRequired = isRequired
        self.isReadOnlyMode = isReadOnlyMode
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
        setupAction()
        setupMode(with: isReadOnlyMode)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateDescription(_ text: String) {
        descriptionLabel.setText(text)
    }
    
    private func setupView() {
        switch type {
        case .category:
            titleLabel.setTitleLabel("카테고리")
            descriptionLabel.setText("색상 수정")
        case .date:
            titleImageView = UIImageView(image: TDImage.Calendar.medium)
            titleImageView?.contentMode = .scaleAspectFit
            titleLabel.setTitleLabel("날짜")
            descriptionLabel.setText("없음")
        case .time:
            titleImageView = UIImageView(image: TDImage.timeSmall)
            titleImageView?.contentMode = .scaleAspectFit
            titleLabel.setTitleLabel("시간")
            descriptionLabel.setText("없음")
        case .cycle:
            titleImageView = UIImageView(image: TDImage.Repeat.cycleMedium)
            titleImageView?.contentMode = .scaleAspectFit
            titleLabel.setTitleLabel("반복")
        case .location:
            titleImageView = UIImageView(image: TDImage.locationMedium)
            titleImageView?.contentMode = .scaleAspectFit
            titleLabel.setTitleLabel("장소")
        }
        if isRequired {
            titleLabel.setRequiredLabel()
        }
        descriptionLabel.setColor(TDColor.Neutral.neutral600)
    }
    
    private func setupLayout() {
        addSubview(containerHorizontalStackView)
        containerHorizontalStackView.addArrangedSubview(titleHorizontalStackView)
        containerHorizontalStackView.addArrangedSubview(descriptionHorizontalStackView)
        
        containerHorizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        if let titleImageView = titleImageView {
            titleHorizontalStackView.addArrangedSubview(titleImageView)
            titleImageView.snp.makeConstraints {
                $0.width.equalTo(20)
                $0.height.equalTo(20)
            }
        }
        titleHorizontalStackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        
        descriptionHorizontalStackView.addArrangedSubview(descriptionLabel)
        descriptionHorizontalStackView.addArrangedSubview(descriptionImageView)
        descriptionImageView.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }
    
    private func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapGesture)
        descriptionHorizontalStackView.isUserInteractionEnabled = true
        descriptionHorizontalStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapView() {
        delegate?.didTapMoveView(self, type: type)
    }
    
    private func setupMode(with isReadOnlyMode: Bool) {
        if isReadOnlyMode {
            descriptionImageView.isHidden = true
            descriptionHorizontalStackView.isUserInteractionEnabled = false
            titleLabel.setTitleFont(TDFont.mediumBody2)
            descriptionLabel.setFont(TDFont.mediumBody2)
        }
    }
}
