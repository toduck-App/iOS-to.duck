import TDDesign
import UIKit

class BaseViewController<LayoutView: BaseView>: UIViewController {
    // MARK: - Properties
    var layoutView = LayoutView()
    var keyboardAdjustableView: UIView?
    
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
        configure()
        addView()
        layout()
        binding()
        configureKeyboardNotification()
        configureDismissKeyboardGesture()
    }
    
    // MARK: - Common Method
    func configure() { }
    func addView() { }
    func layout() { }
    func binding() { }
    
    func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func configureDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let button = keyboardAdjustableView else { return }

        UIView.animate(withDuration: duration) {
            button.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 28)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let button = keyboardAdjustableView else { return }

        UIView.animate(withDuration: duration) {
            button.transform = .identity
        }
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
