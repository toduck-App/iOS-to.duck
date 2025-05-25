import UIKit

/// 선택 상태를 가진 버튼을 나타내는 `TDSelectableButton` 클래스입니다.
public final class TDSelectableButton: TDBaseButton {
    private var selectedBackgroundColor: UIColor = TDColor.Primary.primary100
    private var selectedForegroundColor: UIColor = TDColor.Primary.primary500
    private var deselectedBackgroundColor: UIColor
    private var deselectedForegroundColor: UIColor
    let identifier: String
    
    override
    public var isSelected: Bool {
        didSet {
            if isSelected {
                configuration?.baseBackgroundColor = backgroundToduckColor
                configuration?.baseForegroundColor = foregroundToduckColor
            } else {
                configuration?.baseBackgroundColor = deselectedBackgroundColor
                configuration?.baseForegroundColor = deselectedForegroundColor
            }
        }
    }
    
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
        selectedBackgroundColor: UIColor = TDColor.Primary.primary100,
        selectedForegroundColor: UIColor = TDColor.Primary.primary500,
        radius: CGFloat = 12,
        font: UIFont
    ) {
        self.identifier = title
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedForegroundColor = selectedForegroundColor
        self.deselectedBackgroundColor = backgroundColor
        self.deselectedForegroundColor = foregroundColor
        super.init(
            title: title,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            radius: radius,
            font: font
        )
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func updateConfiguration() {
        super.updateConfiguration()
        if isSelected {
            configuration?.baseBackgroundColor = selectedBackgroundColor
            configuration?.baseForegroundColor = selectedForegroundColor
        } else {
            configuration?.baseBackgroundColor = deselectedBackgroundColor
            configuration?.baseForegroundColor = deselectedForegroundColor
        }
    }
}
