import SnapKit
import TDDesign
import Then
import UIKit

final class WalkThroughView: BaseView {
    // MARK: – UI 컴포넌트
    
    /// 배경 뷰 (하단 40%, 색상 + 그라디언트)
    private let backgroundView = UIView()
    
    /// 상단 페이지 인디케이터
    let dotIndicator = TDDotIndecator(numberOfSteps: 3)
    
    /// 일러스트 이미지
    let illustrationImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    /// 제목 라벨
    let titleLabel = TDLabel(
        toduckFont: .boldHeader2,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    /// 설명 라벨
    let descriptionLabel = TDLabel(
        toduckFont: .regularBody4,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral800
    ).then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.setLineHeightMultiple(1.6)
    }
    
    /// 하단 액션 버튼
    let actionButton = TDButton(
        title: "다음",
        size: .large
    )
    
    // MARK: – Gradient
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: – Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView.backgroundColor = .clear

        let topColor = UIColor(
            red: 176/255,
            green: 161/255,
            blue: 149/255,
            alpha: 0.3
        )
        let bottomColor = UIColor(
            red: 176/255,
            green: 161/255,
            blue: 149/255,
            alpha: 0.12
        )

        gradientLayer.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: – BaseView Override
    
    override func addview() {
        addSubview(backgroundView)
        
        addSubview(dotIndicator)
        addSubview(illustrationImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(actionButton)
    }
    
    override func layout() {
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        dotIndicator.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dotIndicator.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        illustrationImageView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backgroundView.snp.top)
            make.width.equalTo(330)
            make.height.equalTo(372)
        }
        
        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(28)
            make.height.equalTo(48)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundView.bounds
    }
    
    // MARK: – Public API
    
    /// 현재 페이지(단계)를 업데이트 합니다.
    /// - Parameter index: 0...(numberOfSteps-1)
    func setCurrentPage(_ index: Int) {
        dotIndicator.setCurrentStep(index)
    }
}
