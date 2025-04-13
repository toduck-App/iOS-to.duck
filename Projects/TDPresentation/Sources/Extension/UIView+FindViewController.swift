import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}
