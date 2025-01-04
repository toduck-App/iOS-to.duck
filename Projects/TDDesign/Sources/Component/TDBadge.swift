import UIKit

/// 사용자 정의 배지 뷰를 나타내는 `TDBadge` 클래스입니다.
/// 배경 색상, 텍스트 색상, 폰트, 코너 반경 등을 설정할 수 있습니다.
public final class TDBadge: UIView {
    // MARK: - Properties
    
    /// 배지에 표시될 텍스트.
    private var title: String
    
    /// 배지의 배경 색상.
    private var backgroundToduckColor: UIColor
    
    /// 배지의 텍스트 색상.
    private var foregroundToduckColor: UIColor
    
    /// 배지의 모서리 반경.
    private var cornerRadius: CGFloat
    
    /// 배지 텍스트의 폰트.
    private var font: TDFont
    
    /// 배지에 표시되는 텍스트를 담당하는 `TDLabel`.
    private var label: TDLabel
    
    // MARK: - Initializers
    
    /// `TDBadge`의 기본 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - frame: 뷰의 프레임. 기본값은 `.zero`입니다.
    ///   - title: 배지에 표시될 텍스트.
    ///   - font: 배지 텍스트의 폰트.
    ///   - backgroundToduckColor: 배지의 배경 색상.
    ///   - foregroundToduckColor: 배지의 텍스트 색상.
    ///   - cornerRadius: 배지의 모서리 반경.
    public init(frame: CGRect = .zero,
                title: String,
                font: TDFont,
                backgroundToduckColor: UIColor,
                foregroundToduckColor: UIColor,
                cornerRadius: CGFloat)
    {
        self.title = title
        self.font = font
        self.backgroundToduckColor = backgroundToduckColor
        self.foregroundToduckColor = foregroundToduckColor
        self.cornerRadius = cornerRadius
        label = TDLabel(labelText: title, toduckFont: self.font, toduckColor: self.foregroundToduckColor)
        super.init(frame: .zero)

        setupBadge()
        layout()
    }
    
    /// 편의 이니셜라이저로, 배지 제목만 전달받아 기본 색상을 사용하여 `TDBadge`를 생성합니다.
    ///
    /// - Parameter badgeTitle: 배지에 표시될 텍스트.
    public convenience init(badgeTitle: String) {
        self.init(badgeTitle: badgeTitle, backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary200)
    }
    
    /// 편의 이니셜라이저로, 배지 제목과 배경/전경 색상을 전달받아 `TDBadge`를 생성합니다.
    ///
    /// - Parameters:
    ///   - badgeTitle: 배지에 표시될 텍스트.
    ///   - backgroundColor: 배지의 배경 색상.
    ///   - foregroundColor: 배지의 텍스트 색상.
    public convenience init(badgeTitle: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        self.init(
            title: badgeTitle,
            font: .mediumCaption2, // 기본 폰트 설정
            backgroundToduckColor: backgroundColor,
            foregroundToduckColor: foregroundColor,
            cornerRadius: 4 // 기본 코너 반경 설정
        )
    }
    
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    /// 배지의 기본 설정을 구성합니다.
    private func setupBadge() {
        label.sizeToFit()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        backgroundColor = backgroundToduckColor
    }
    
    /// 배지의 레이아웃을 설정합니다.
    private func layout() {
        addSubview(label)
        
        // 배지의 높이를 20으로 고정
        snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        // 라벨의 제약조건 설정: 좌우 여백 10, 상하 경계에 맞춤
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.top.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    /// 배지의 제목을 변경합니다.
    ///
    /// - Parameter title: 새로운 배지 제목.
    public func setTitle(_ title: String) {
        self.title = title
        label.setText(self.title)
        setupBadge()
    }
    
    /// 배지의 폰트를 변경합니다.
    ///
    /// - Parameter font: 새로운 배지 폰트.
    public func setFont(_ font: TDFont) {
        self.font = font
        label.setFont(font)
        setupBadge()
    }
    
    /// 배지의 코너 반경을 변경합니다.
    ///
    /// - Parameter cornerRadius: 새로운 코너 반경 값.
    public func setCornerRadius(_ cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius
        setupBadge()
    }
    
    /// 배지의 텍스트 색상을 변경합니다.
    ///
    /// - Parameter titleColor: 새로운 텍스트 색상.
    public func setTitleColor(_ titleColor: UIColor) {
        foregroundToduckColor = titleColor
        label.setColor(foregroundToduckColor)
        setupBadge()
    }
    
    /// 배지의 배경 색상을 변경합니다.
    ///
    /// - Parameter backgroundToduckColor: 새로운 배경 색상.
    public func setBackgroundToduckColor(_ backgroundToduckColor: UIColor) {
        self.backgroundToduckColor = backgroundToduckColor
        backgroundColor = backgroundToduckColor
        setupBadge()
    }
}
