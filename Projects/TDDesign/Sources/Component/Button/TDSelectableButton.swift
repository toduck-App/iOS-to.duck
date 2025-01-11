import UIKit

/// 선택 상태를 가진 버튼을 나타내는 `TDSelectableButton` 클래스입니다.
public final class TDSelectableButton: TDBaseButton {
    private var selectedBackgroundColor: UIColor = TDColor.Primary.primary100
    private var selectedForegroundColor: UIColor = TDColor.Primary.primary500
    
    // MARK: - Initializers
    
    /// `TDSelectableButton`의 기본 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - frame: 버튼의 프레임. 기본값은 `.zero`입니다.
    ///   - title: 버튼에 표시될 텍스트.
    public init(
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        radius: CGFloat = 12,
        font: UIFont
    ) {
        super.init(
            title: title,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            radius: radius,
            font: font
        )
        
        addAction(UIAction { [weak self] _ in
            self?.buttonTapped()
        }, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func buttonTapped() {
        isSelected.toggle()
        updateConfiguration()
    }
    
    // MARK: - Update Configuration
    override public func updateConfiguration() {
        super.updateConfiguration()
        
        if isSelected {
            configuration?.baseBackgroundColor = selectedBackgroundColor
            configuration?.baseForegroundColor = selectedForegroundColor
        } else {
            configuration?.baseBackgroundColor = backgroundToduckColor
            configuration?.baseForegroundColor = foregroundToduckColor
        }
    }
}
