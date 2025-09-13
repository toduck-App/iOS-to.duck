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
    private var labelText: String {
        didSet {
            super.text = labelText
            applyAttributes()
        }
    }
    
    // MARK: - Initialization
    
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
        self.toduckFont = toduckFont
        self.alignment = alignment
        self.toduckColor = toduckColor
        self.labelText = labelText
        
        super.init(frame: frame)
        applyAttributes()
    }
    
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
    
    public required init?(coder: NSCoder) {
        self.toduckFont = TDFont.mediumHeader5
        self.alignment = .justified
        self.toduckColor = TDColor.Neutral.neutral800
        self.labelText = ""
        
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
        let lineHeight = toduckFont.size * toduckFont.lineHeightMultiple
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
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
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: labelText))
        let range = NSRange(location: 0, length: labelText.count)
        
        attributedString.addAttribute(
            .font,
            value: toduckFont.font,
            range: range
        )
        
        attributedText = attributedString
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
    }
    
    /// 라벨의 행간을 변경합니다.
    /// - Parameter lineHeightMultiple: 새로 적용할 행간 (CGFloat)
    public func setLineHeightMultiple(_ lineHeightMultiple: CGFloat) {
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: labelText))
        let range = NSRange(location: 0, length: labelText.count)
        let paragraphStyle = NSMutableParagraphStyle()
        let lineHeight = toduckFont.size * lineHeightMultiple
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = alignment
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: range
        )
        
        attributedText = attributedString
    }
    
    // 하이라이트 옵션
    public struct HighlightOptions: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        public static let caseInsensitive = HighlightOptions(rawValue: 1 << 0)
        public static let wholeWord = HighlightOptions(rawValue: 1 << 1)
        public static let regex = HighlightOptions(rawValue: 1 << 2)
    }

    // 토큰별 스펙 (색 + 폰트)
    public struct HighlightSpec {
        public let token: String
        public let color: UIColor
        public let font: TDFont?
        public let options: HighlightOptions

        public init(
            token: String,
            color: UIColor,
            font: TDFont? = nil,
            options: HighlightOptions = [.caseInsensitive]
        ) {
            self.token = token
            self.color = color
            self.font = font
            self.options = options
        }
    }

    /// 전체 하이라이트 제거(색상만 기본으로 리셋, 기존 폰트/커닝/문단 스타일 유지)
    public func clearHighlights() {
        if attributedText == nil { applyAttributes() } // 기존 클래스 메서드 그대로 호출
        let base = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: text ?? ""))
        let rAll = NSRange(location: 0, length: (base.string as NSString).length)
        base.addAttribute(.foregroundColor, value: textColor ?? UIColor.label, range: rAll)
        attributedText = base
    }

    /// 모든 토큰에 같은 색/폰트/옵션을 적용
    public func highlight(
        tokens: [String],
        color: UIColor,
        font: TDFont? = nil,
        options: HighlightOptions = [.caseInsensitive]
    ) {
        let specs = tokens.map { HighlightSpec(token: $0, color: color, font: font, options: options) }
        highlight(specs)
    }

    /// 상세 API: 토큰별 스펙 지정
    public func highlight(_ specs: [HighlightSpec]) {
        if attributedText == nil { applyAttributes() }
        let base = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: text ?? ""))
        let ns = base.string as NSString
        let rAll = NSRange(location: 0, length: ns.length)

        base.addAttribute(.foregroundColor, value: textColor ?? UIColor.label, range: rAll)

        func applyHighlight(range r: NSRange, spec: HighlightSpec) {
            base.addAttribute(.foregroundColor, value: spec.color, range: r)
            if let f = spec.font {
                base.addAttribute(.font, value: f.font, range: r)
            }
        }

        for spec in specs where !spec.token.isEmpty {
            if spec.options.contains(.regex) {
                let regexOpts: NSRegularExpression.Options = spec.options.contains(.caseInsensitive) ? [.caseInsensitive] : []
                if let re = try? NSRegularExpression(pattern: spec.token, options: regexOpts) {
                    re.enumerateMatches(in: base.string, options: [], range: rAll) { m, _, _ in
                        guard let r = m?.range, r.location != NSNotFound, r.length > 0 else { return }
                        applyHighlight(range: r, spec: spec)
                    }
                }
            } else if spec.options.contains(.wholeWord) {
                let escaped = NSRegularExpression.escapedPattern(for: spec.token)
                let pattern = #"(?<![\p{L}\p{N}])\#(escaped)(?![\p{L}\p{N}])"#
                let regexOpts: NSRegularExpression.Options = spec.options.contains(.caseInsensitive) ? [.caseInsensitive] : []
                if let re = try? NSRegularExpression(pattern: pattern, options: regexOpts) {
                    re.enumerateMatches(in: base.string, options: [], range: rAll) { m, _, _ in
                        guard let r = m?.range, r.location != NSNotFound, r.length > 0 else { return }
                        applyHighlight(range: r, spec: spec)
                    }
                }
            } else {
                let cmp: NSString.CompareOptions = spec.options.contains(.caseInsensitive) ? [.caseInsensitive] : []
                var search = rAll
                while true {
                    let found = ns.range(of: spec.token, options: cmp, range: search)
                    if found.location == NSNotFound { break }
                    applyHighlight(range: found, spec: spec)
                    let next = found.location + found.length
                    if next >= ns.length { break }
                    search = NSRange(location: next, length: ns.length - next)
                }
            }
        }

        attributedText = base
    }
}
