import TDDesign
import UIKit

class BaseViewController<LayoutView: BaseView>: UIViewController {

    var layoutView = LayoutView()
    func layout() {}
    func configure() {}
    func addView() {}
    func binding() {}
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.addView()
        self.layout()
        self.binding()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.endEditing(true)
    }
    
    override func loadView() {
        if layoutView.backgroundColor == nil {
            layoutView.backgroundColor = TDColor.Neutral.neutral50
        }
        view = layoutView
    }
}
