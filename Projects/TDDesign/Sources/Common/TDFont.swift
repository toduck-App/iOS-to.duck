import UIKit

public enum TDFont {
    case mediumHeader1
    case mediumHeader2
    case mediumHeader3
    case mediumHeader4
    case mediumHeader5
    
    case boldHeader1
    case boldHeader2
    case boldHeader3
    case boldHeader4
    case boldHeader5
    
    case mediumBody1
    case boldBody1
    
    case regularBody2
    case mediumBody2
    case boldBody2
    
    case regularBody3
    case mediumBody3
    case boldBody3
    
    case regularBody4
    
    case mediumButton
    case boldButton
    
    case regularCaption1
    case mediumCaption1
    case boldCaption1
    
    case regularCaption2
    case mediumCaption2
    case boldCaption2
    
    case regularCaption3
    case mediumCaption3
}

extension TDFont {
    public var font: UIFont {
        switch self {
        case .mediumHeader1:
            return TDDesignFontFamily.Pretendard.medium.font(size: 34.0)
        case .mediumHeader2:
            return TDDesignFontFamily.Pretendard.medium.font(size: 24.0)
        case .mediumHeader3:
            return TDDesignFontFamily.Pretendard.medium.font(size: 20.0)
        case .mediumHeader4:
            return TDDesignFontFamily.Pretendard.medium.font(size: 18.0)
        case .mediumHeader5:
            return TDDesignFontFamily.Pretendard.medium.font(size: 16.0)
        case .boldHeader1:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 34.0)
        case .boldHeader2:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 24.0)
        case .boldHeader3:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 20.0)
        case .boldHeader4:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 18.0)
        case .boldHeader5:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 16.0)
        case .mediumBody1:
            return TDDesignFontFamily.Pretendard.medium.font(size: 16.0)
        case .boldBody1:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 16.0)
        case .regularBody2:
            return TDDesignFontFamily.Pretendard.regular.font(size: 14.0)
        case .mediumBody2:
            return TDDesignFontFamily.Pretendard.medium.font(size: 14.0)
        case .boldBody2:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 14.0)
        case .regularBody3:
            return TDDesignFontFamily.Pretendard.regular.font(size: 14.0)
        case .mediumBody3:
            return TDDesignFontFamily.Pretendard.medium.font(size: 14.0)
        case .boldBody3:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 14.0)
        case .regularBody4:
            return TDDesignFontFamily.Pretendard.regular.font(size: 15.0)
        case .mediumButton:
            return TDDesignFontFamily.Pretendard.medium.font(size: 12.0)
        case .boldButton:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 12.0)
        case .regularCaption1:
            return TDDesignFontFamily.Pretendard.regular.font(size: 12.0)
        case .mediumCaption1:
            return TDDesignFontFamily.Pretendard.medium.font(size: 12.0)
        case .boldCaption1:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 12.0)
        case .regularCaption2:
            return TDDesignFontFamily.Pretendard.regular.font(size: 10.0)
        case .mediumCaption2:
            return TDDesignFontFamily.Pretendard.medium.font(size: 10.0)
        case .boldCaption2:
            return TDDesignFontFamily.Pretendard.semiBold.font(size: 10.0)
        case .regularCaption3:
            return TDDesignFontFamily.Pretendard.regular.font(size: 9.0)
        case .mediumCaption3:
            return TDDesignFontFamily.Pretendard.medium.font(size: 9.0)
        }
    }
    
    public var size: CGFloat {
        switch self {
        case .mediumHeader1,
                .boldHeader1:
            return 34.0
        case .mediumHeader2,
                .boldHeader2:
            return 24.0
        case .mediumHeader3,
                .boldHeader3:
            return 20.0
        case .mediumHeader4,
                .boldHeader4:
            return 18.0
        case .mediumHeader5,
                .boldHeader5,
                .mediumBody1,
                .boldBody1:
            return 16.0
        case .regularBody2,
                .mediumBody2,
                .boldBody2,
                .regularBody3,
                .mediumBody3,
                .boldBody3:
            return 14.0
        case .regularBody4:
            return 15.0
        case .mediumButton,
                .boldButton,
                .regularCaption1,
                .mediumCaption1,
                .boldCaption1:
            return 12.0
        case .regularCaption2,
                .mediumCaption2,
                .boldCaption2:
            return 10.0
        case .regularCaption3,
                .mediumCaption3:
            return 9.0
        }
    }
    
    var letterSpacing: CGFloat {
        return -0.02
    }
    
    var lineHeightMultiple: CGFloat {
        switch self {
        case .regularBody4:
            return 1.6
        default:
            return 1.1
        }
    }
}
