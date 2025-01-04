import UIKit

/// 선택 상태를 가진 버튼을 나타내는 `TDSelectableButton` 클래스입니다.
public final class TDSelectableButton: TDBaseButton {
    
    // MARK: - Initializers
    
    /// `TDSelectableButton`의 기본 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - frame: 버튼의 프레임. 기본값은 `.zero`입니다.
    ///   - title: 버튼에 표시될 텍스트.
    public init(frame: CGRect = .zero, title: String) {
        super.init(
            frame: frame,
            title: title,
            backgroundColor: TDColor.Primary.primary50,
            foregroundColor: TDColor.Primary.primary500
        )
        setFont(toduckFont: .mediumBody1)
        
        // 버튼 클릭 시 `buttonTapped` 메서드가 호출되도록 설정
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    /// 버튼의 기본 설정을 구성합니다.
    /// 배경 색상, 제목 색상, 테두리 색상 및 두께를 설정합니다.
    public override func setupButton() {
        super.setupButton()
        
        backgroundColor = TDColor.Neutral.neutral50
        setTitleColor(TDColor.Neutral.neutral600, for: .normal)
        layer.borderColor = TDColor.Primary.primary500.cgColor
        layer.borderWidth = 0
    }
    
    /// 선택 상태에 따라 배경 색상과 제목 색상을 업데이트합니다.
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = backgroundToduckColor
                setTitleColor(foregroundToduckColor, for: .normal)
            } else {
                backgroundColor = TDColor.Neutral.neutral50
                setTitleColor(TDColor.Neutral.neutral600, for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    
    /// 버튼이 탭되었을 때 호출되는 메서드입니다.
    @objc
    private func buttonTapped() {
        isSelected.toggle()
    }
}
