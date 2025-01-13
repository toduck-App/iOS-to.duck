import UIKit

extension String {
    /// 16진수 문자열을 UIColor로 변환
    func convertToUIColor() -> UIColor? {
        // # 제거
        var hexString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // 문자열 길이 확인
        guard hexString.count == 6 else { return nil }
        
        // RGB 값 추출
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
