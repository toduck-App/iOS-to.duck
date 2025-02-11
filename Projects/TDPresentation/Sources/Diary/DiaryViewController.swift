import TDDesign
import UIKit
import TDCore

final class DiaryViewController: UIViewController {
    weak var coordinator: DiaryCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(style: .diary, navigationDelegate: coordinator!) {
            TDLogger.debug("MyPageViewController - setupNavigationBar")
        }
        self.view.backgroundColor = .systemGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.backgroundColor = TDColor.baseBlack
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.backgroundColor = TDColor.baseWhite
    }
}
