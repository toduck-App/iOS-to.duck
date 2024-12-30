import TDDesign
import UIKit

class BaseViewController<LayoutView: BaseView>: UIViewController {
    // MARK: - Properties
    var layoutView = LayoutView()
    
    // MARK: - Initialize
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        if layoutView.backgroundColor == nil {
            layoutView.backgroundColor = TDColor.Neutral.neutral50
        }
        view = layoutView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.addView()
        self.layout()
        self.binding()
    }
    
    // MARK: - Common Method
    func layout() { }
    func configure() { }
    func addView() { }
    func binding() { }
}
