import SnapKit
import Then
import UIKit

public enum TDFormMoveViewType {
    case category
    case date
    case time
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
    private let titleLabel = TDLabel(toduckFont: .mediumBody1)
    
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
    private let action: (() -> Void)?
    
    // MARK: - Initializer
    public init(
        type: TDFormMoveViewType,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.action = action
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
        setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        switch type {
        case .category:
            titleLabel.setText("카테고리")
            descriptionLabel.setText("색상 수정")
        case .date:
            titleImageView = UIImageView(image: TDImage.Calendar.medium)
            titleImageView?.contentMode = .scaleAspectFit
            titleLabel.setText("날짜")
            descriptionLabel.setText("없음")
        case .time:
            titleImageView = UIImageView(image: TDImage.timeSmall)
            titleImageView?.contentMode = .scaleAspectFit
            titleLabel.setText("시간")
            descriptionLabel.setText("없음")
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
        action?()
    }
}
