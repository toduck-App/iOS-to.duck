import UIKit
class BaseView: UIView {
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addview()
        self.configure()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: - Common Method
    func addview() {}
    func configure() {}
    func layout() {}
}
