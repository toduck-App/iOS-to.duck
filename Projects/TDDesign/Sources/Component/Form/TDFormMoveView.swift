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
    private let titleHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private var titleImageView: UIImageView?
    private let titleLabel = UILabel()
    
    private let descriptionHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let descriptionLabel = UILabel()
    private let descriptionImageView = UIImageView(image: TDImage.Direction.right2Medium)
    
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
            titleLabel.text = "카테고리"
            descriptionLabel.text = "색상 수정"
        case .date:
            titleImageView = UIImageView(image: TDImage.Calendar.medium)
            titleLabel.text = "날짜"
            descriptionLabel.text = "없음"
        case .time:
            titleImageView = UIImageView(image: TDImage.timeSmall)
            titleLabel.text = "시간"
            descriptionLabel.text = "없음"
        }
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
            $0.width.equalTo(44)
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
        print(123)
        action?()
    }
}
