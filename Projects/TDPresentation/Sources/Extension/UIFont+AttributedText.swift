import UIKit

extension UIFont {
    /// 특정 부분만 스타일을 변경하는 AttributedString 생성 메서드
    /// - Parameters:
    ///  - mainText: 전체 텍스트
    ///  - coloredPart: 스타일을 변경할 부분
    ///  - mainFont: 전체 텍스트 폰트
    ///  - mainColor: 전체 텍스트 색상
    ///  - highlightFont: 스타일을 변경할 부분 폰트
    ///  - highlightColor: 스타일을 변경할 부분 색상
    static func makeAttributedText(
        mainText: String,
        coloredPart: String,
        mainFont: UIFont,
        mainColor: UIColor,
        highlightFont: UIFont,
        highlightColor: UIColor
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: mainText, attributes: [
            .font: mainFont,
            .foregroundColor: mainColor
        ])
        
        let range = (mainText as NSString).range(of: coloredPart)
        if range.location != NSNotFound {
            attributedString.addAttributes([
                .font: highlightFont,
                .foregroundColor: highlightColor
            ], range: range)
        }
        
        return attributedString
    }
}
