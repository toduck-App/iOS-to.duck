import SnapKit
import Then
import UIKit

public final class TDFormRecommendRoutine: UIView {
    // MARK: - UI Components
    private let separatorView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
    }
    private let recommendRoutineLabel = TDLabel(
        labelText: "회원님을 위한 루틴 추천",
        toduckFont: TDFont.boldHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let popularityHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let popularityImageView = UIImageView().then {
        $0.image = TDImage.goodMedium
        $0.contentMode = .scaleAspectFit
    }
    private let popularityLabel = TDLabel(
        labelText: "인기",
        toduckFont: TDFont.boldHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    // MARK: - Initializer
    public init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupLayout() {
        addSubview(separatorView)
        addSubview(recommendRoutineLabel)
        addSubview(popularityHorizontalStackView)
        
        separatorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        recommendRoutineLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        popularityHorizontalStackView.snp.makeConstraints {
            $0.top.equalTo(recommendRoutineLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        popularityHorizontalStackView.addArrangedSubview(popularityImageView)
        popularityHorizontalStackView.addArrangedSubview(popularityLabel)
    }
}
