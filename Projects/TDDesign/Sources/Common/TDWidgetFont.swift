import SwiftUI

// MARK: - Public API
public enum TDFontSwiftUI {
    case mediumHeader1, mediumHeader2, mediumHeader3, mediumHeader4, mediumHeader5
    case boldHeader1, boldHeader2, boldHeader3, boldHeader4, boldHeader5

    case mediumBody1, boldBody1

    case regularBody2, mediumBody2, boldBody2
    case regularBody3, mediumBody3, boldBody3
    
    case regularBody4

    case mediumButton, boldButton

    case regularCaption1, mediumCaption1, boldCaption1
    case regularCaption2, mediumCaption2, boldCaption2
    case regularCaption3, mediumCaption3
}

// MARK: - Internal Font Registry (1회 등록 보장)
private enum _TDDesignFontRegistry {
    private static var didRegister = false
    static func ensureRegistered() {
        guard !didRegister else { return }
        TDDesignFontFamily.registerAllCustomFonts()
        didRegister = true
    }
}

// MARK: - Mapping
extension TDFontSwiftUI {
    /// Tuist가 만든 폰트 컨버터로 매핑 (문자열 하드코딩 제거)
    private var fontConvertible: TDDesignFontConvertible {
        switch self {
        // Medium
        case .mediumHeader1, .mediumHeader2, .mediumHeader3, .mediumHeader4, .mediumHeader5,
             .mediumBody1, .mediumBody2, .mediumBody3,
             .mediumButton,
             .mediumCaption1, .mediumCaption2, .mediumCaption3:
            return TDDesignFontFamily.Pretendard.medium

        // SemiBold
        case .boldHeader1, .boldHeader2, .boldHeader3, .boldHeader4, .boldHeader5,
             .boldBody1, .boldBody2, .boldBody3,
             .boldButton,
             .boldCaption1, .boldCaption2:
            return TDDesignFontFamily.Pretendard.semiBold

        // Regular
        case .regularBody2, .regularBody3, .regularBody4,
             .regularCaption1, .regularCaption2, .regularCaption3:
            return TDDesignFontFamily.Pretendard.regular
        }
    }

    public var size: CGFloat {
        switch self {
        case .mediumHeader1, .boldHeader1: return 34
        case .mediumHeader2, .boldHeader2: return 24
        case .mediumHeader3, .boldHeader3: return 20
        case .mediumHeader4, .boldHeader4: return 18
        case .mediumHeader5, .boldHeader5, .mediumBody1, .boldBody1: return 16
        case .regularBody2, .mediumBody2, .boldBody2,
             .regularBody3, .mediumBody3, .boldBody3: return 14
        case .regularBody4: return 15
        case .mediumButton, .boldButton,
             .regularCaption1, .mediumCaption1, .boldCaption1: return 12
        case .regularCaption2, .mediumCaption2, .boldCaption2: return 10
        case .regularCaption3, .mediumCaption3: return 9
        }
    }

    /// Dynamic Type 대응 기준
    private var relativeTextStyle: Font.TextStyle {
        switch self {
        case .mediumHeader1, .boldHeader1: return .largeTitle
        case .mediumHeader2, .boldHeader2: return .title
        case .mediumHeader3, .boldHeader3: return .title2
        case .mediumHeader4, .boldHeader4: return .title3

        case .mediumHeader5, .boldHeader5,
             .mediumBody1, .boldBody1,
             .regularBody2, .mediumBody2, .boldBody2,
             .regularBody3, .mediumBody3, .boldBody3,
             .regularBody4:
            return .body

        case .mediumButton, .boldButton,
             .regularCaption1, .mediumCaption1, .boldCaption1:
            return .caption

        case .regularCaption2, .mediumCaption2, .boldCaption2,
             .regularCaption3, .mediumCaption3:
            return .caption2
        }
    }

    // UIKit 스펙 반영
    private var letterSpacingEm: CGFloat { -0.02 }
    public var tracking: CGFloat { size * letterSpacingEm }

    /// lineHeightMultiple = 1.6(regularBody4), 그 외 1.1
    private var lineHeightMultiple: CGFloat {
        switch self {
        case .regularBody4: return 1.6
        default: return 1.1
        }
    }
    /// SwiftUI 근사치: lineSpacing(pt) = (multiple - 1) * size
    public var lineSpacing: CGFloat { size * (lineHeightMultiple - 1) }

    /// 최종 SwiftUI.Font
    public var font: Font {
        _TDDesignFontRegistry.ensureRegistered()
        // Tuist 컨버터의 name을 사용해 Dynamic Type 대응되는 Font.custom 생성
        return .custom(fontConvertible.name, size: size, relativeTo: relativeTextStyle)
    }

    /// 필요 시: Tuist 컨버터의 swiftUIFont(size:)를 직접 쓰고 싶을 때 (Dynamic Type 비권장)
    public var bridgedFont: Font {
        _TDDesignFontRegistry.ensureRegistered()
        return fontConvertible.swiftUIFont(size: size)
    }
}

// MARK: - Modifiers

/// Text 전용: Font + tracking + lineSpacing 한번에 적용
public struct TDFontTextModifier: ViewModifier {
    let style: TDFontSwiftUI
    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
    }
}

public extension Text {
    /// Text는 자간/라인스페이싱까지 한 번에
    func tdFont(_ style: TDFontSwiftUI) -> some View {
        self.modifier(TDFontTextModifier(style: style))
    }
}

public extension View {
    /// Text 외의 컨트롤(Label, Button 등)에는 폰트만 적용
    func tdFont(_ style: TDFontSwiftUI) -> some View {
        self.font(style.font)
    }
}
