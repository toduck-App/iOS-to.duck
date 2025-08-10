import Foundation
import TDDesign

import SwiftUI
import TDDesign

public enum CustomFont {
    case pretendardRegular
    case pretendardMedium
    case pretendardSemiBold
    case pretendardBold

    private var convertible: TDDesignFontConvertible {
        switch self {
        case .pretendardRegular: TDDesignFontFamily.Pretendard.regular
        case .pretendardMedium: TDDesignFontFamily.Pretendard.medium
        case .pretendardSemiBold: TDDesignFontFamily.Pretendard.semiBold
        case .pretendardBold: TDDesignFontFamily.Pretendard.bold
        }
    }

    public var name: String { self.convertible.name }

    // MARK: - SwiftUI Font

    /// 고정 크기 (Dynamic Type 비활성화)
    public func fixedFont(_ size: CGFloat) -> Font {
        .custom(self.name, fixedSize: size)
    }

    /// 기존처럼 단순 size만 주는 버전 (Dynamic Type 미사용)
    public func font(size: CGFloat) -> Font {
        .custom(self.name, size: size)
    }
}

public extension Font {
    /// 기존처럼 단순 size만 주는 버전 (Dynamic Type 미사용)
    static func custom(_ font: CustomFont, size: CGFloat) -> Font {
        font.font(size: size)
    }

    /// 고정 크기 (Dynamic Type 비활성화)
    static func custom(_ font: CustomFont, fixedSize: CGFloat) -> Font {
        font.fixedFont(fixedSize)
    }
}

extension View {
    func customFont(_ font: CustomFont, style: UIFont.TextStyle) -> some View {
        self.font(.custom(font, size: UIFont.preferredFont(forTextStyle: style).pointSize))
    }

    func customFont(_ font: CustomFont, size: CGFloat) -> some View {
        self.font(.custom(font, size: size))
    }

    func customFont(_ font: CustomFont, fixedSize: CGFloat) -> some View {
        self.font(.custom(font, fixedSize: fixedSize))
    }
}
