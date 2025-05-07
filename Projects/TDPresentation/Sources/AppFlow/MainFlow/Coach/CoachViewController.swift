import TDDesign
import UIKit

final class CoachViewViewController: BaseViewController<CoachView>, UIGestureRecognizerDelegate {
    weak var coordinator: CoachCoordinator?
    let image = [
        TDImage.CoachMark.first,
        TDImage.CoachMark.second,
        TDImage.CoachMark.third
    ]
    var currentPage = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        layoutView.configure(image: image[currentPage])
        layoutView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(nextTapped))
        tapGR.delegate = self
        tapGR.cancelsTouchesInView = false
        layoutView.imageView.addGestureRecognizer(tapGR)
    }
    
    @objc private func closeTapped() {
        coordinator?.finish(by: .popNotAnimated)
    }
    
    @objc private func nextTapped() {
        if currentPage >= image.count - 1 {
            coordinator?.finish(by: .popNotAnimated)
            return
        }
        currentPage += 1
        layoutView.configure(image: image[currentPage])
    }
    
    // MARK: – UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view,
           touchedView.isDescendant(of: layoutView.closeButton) {
            return false
        }
        return true
    }

}
