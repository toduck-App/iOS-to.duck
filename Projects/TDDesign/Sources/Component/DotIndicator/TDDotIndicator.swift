import SnapKit
import Then
import UIKit

public final class TDDotIndecator: UIView {
    // MARK: – Private Properties
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    /// 총 단계 수 (immutable)
    private let totalSteps: Int
    
    /// 현재 활성화된 단계 인덱스 (0부터 시작)
    private var currentIndex: Int = 0
    
    // MARK: – Init
    
    /// - Parameter numberOfSteps: 표시할 도트(단계) 개수
    public init(numberOfSteps steps: Int) {
        self.totalSteps = max(0, steps)
        super.init(frame: .zero)
        
        setupLayout()
        setupDots()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: – Public API
    
    /// 현재 단계를 설정하고 도트 모양을 갱신
    /// - Parameter index: 활성화할 단계 인덱스 (0…numberOfSteps-1)
    public func setCurrentStep(_ index: Int) {
        guard index >= 0, index < totalSteps else { return }
        currentIndex = index
        updateDots()
    }
    
    // MARK: – Layout
    
    /// 스택뷰를 뷰 전체에 꽉 채워 배치
    private func setupLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: – Dot 생성 & 업데이트
    
    /// 초기화 시, totalSteps 에 따라 도트를 생성
    private func setupDots() {
        for arrangedSubview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        for _ in 0 ..< totalSteps {
            let dot = UIView()
            dot.layer.masksToBounds = true
            stackView.addArrangedSubview(dot)
        }
        updateDots()
    }
    
    /// currentIndex 에 따라 각 도트의 크기·radius·색상 업데이트
    private func updateDots() {
        for (idx, dot) in stackView.arrangedSubviews.enumerated() {
            let isActive = (idx == currentIndex)
            
            dot.snp.remakeConstraints { make in
                make.width.equalTo(isActive ? 16 : 6)
                make.height.equalTo(6)
            }
            dot.layer.cornerRadius = 3
            
            dot.backgroundColor = isActive
                ? TDColor.Primary.primary500
                : TDColor.Neutral.neutral500
        }
    }
}
