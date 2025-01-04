import UIKit

/// 커스텀 라벨 클래스: 텍스트, 폰트, 정렬, 색상을 자유롭게 지정할 수 있습니다.
public final class TDLabel: UILabel {
    // MARK: - Private Properties
    
    /// 커스텀 폰트를 나타내는 프로퍼티 (TDFont)
    private var toduckFont: TDFont
    
    /// 텍스트 정렬을 나타내는 프로퍼티 (NSTextAlignment)
    private var alignment: NSTextAlignment
    
    /// 텍스트 색상을 나타내는 프로퍼티 (UIColor)
    private var toduckColor: UIColor
    
    /// 라벨에 표시할 텍스트
    private var labelText: String
    
    // MARK: - Initialization
    
    /// `TDLabel`의 Convenience 이니셜라이저입니다.
    /// frame, labelText가 기본값(.zero, "")으로 설정되며,
    /// 필요한 경우 alignment, toduckColor만 따로 지정할 수 있습니다.
    ///
    /// - Parameters:
    ///   - toduckFont: 커스텀 폰트 (TDFont)
    ///   - toduckColor: 텍스트 컬러 (기본값: TDColor.Neutral.neutral800)
    public convenience init(
        toduckFont: TDFont,
        toduckColor: UIColor = TDColor.Neutral.neutral800
    ) {
        self.init(
            frame: .zero,
            labelText: "",
            toduckFont: toduckFont,
            alignment: .justified,
            toduckColor: toduckColor
        )
    }
    
    /// `TDLabel`의 지정(Designated) 이니셜라이저입니다.
    ///
    /// - Parameters:
    ///   - frame: 라벨의 프레임 (기본값: .zero)
    ///   - labelText: 라벨에 표시할 텍스트 (기본값: "")
    ///   - toduckFont: 커스텀 폰트 (TDFont)
    ///   - alignment: 텍스트 정렬 (기본값: .justified)
    ///   - toduckColor: 텍스트 컬러 (기본값: TDColor.Neutral.neutral800)
    public init(
        frame: CGRect = .zero,
        labelText: String = "",
        toduckFont: TDFont,
        alignment: NSTextAlignment = .justified,
        toduckColor: UIColor = TDColor.Neutral.neutral800
    ) {
        self.labelText = labelText
        self.toduckFont = toduckFont
        self.alignment = alignment
        self.toduckColor = toduckColor
        
        super.init(frame: frame)
        applyAttributes()
    }
    
    public required init?(coder: NSCoder) {
        self.labelText = ""
        self.toduckFont = TDFont.mediumHeader5
        self.alignment = .justified
        self.toduckColor = TDColor.Neutral.neutral800
        
        super.init(coder: coder)
        applyAttributes()
    }
    
    // MARK: - Private Methods
    
    /// 라벨에 필요한 속성(Font, Color, Spacing 등)을 적용합니다.
    private func applyAttributes() {
        // NSMutableAttributedString을 사용하여 속성을 일괄 적용
        let attributedString = NSMutableAttributedString(string: labelText)
        let range = NSRange(location: 0, length: attributedString.length)
        
        // 폰트 적용
        attributedString.addAttribute(
            .font,
            value: toduckFont.font,
            range: range
        )
        
        // 텍스트 색상 적용
        attributedString.addAttribute(
            .foregroundColor,
            value: toduckColor,
            range: range
        )
        
        // 글자 간격 적용
        attributedString.addAttribute(
            .kern,
            value: toduckFont.letterSpacing,
            range: range
        )
        
        // 문단 스타일(줄간격, 정렬 등) 적용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = toduckFont.lineHeightMultiple
        paragraphStyle.alignment = alignment
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: range
        )
        
        // 최종적으로 라벨에 AttributedString 적용
        attributedText = attributedString
        textColor = toduckColor
    }
    
    // MARK: - Public Methods
    
    /// 라벨의 폰트를 변경합니다.
    /// - Parameter font: 새로 적용할 TDFont
    public func setFont(_ font: TDFont) {
        toduckFont = font
        applyAttributes()
    }
    
    /// 라벨의 텍스트 컬러를 변경합니다.
    /// - Parameter color: 새로 적용할 UIColor
    public func setColor(_ color: UIColor) {
        toduckColor = color
        applyAttributes()
    }
    
    /// 라벨의 텍스트를 변경합니다.
    /// - Parameter text: 새로 적용할 텍스트
    public func setText(_ text: String) {
        labelText = text
        applyAttributes()
    }
}
