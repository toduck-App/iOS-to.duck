import UIKit

extension UIColor {
    func convertToHexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let rgb: Int = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        return String(format: "#%06X", rgb)
    }
}
