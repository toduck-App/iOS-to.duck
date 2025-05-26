import FirebaseAnalytics
import FirebaseCrashlytics
import TDDesign
import UIKit

class BaseViewController<LayoutView: BaseView>: UIViewController {
    // MARK: - Properties
    var layoutView = LayoutView()
    var keyboardAdjustableView: UIView?
    private var enterTime: Date?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enterTime = Date()
        trackScreenAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        trackScreenDuration(startTime: enterTime)
    }
    
    // MARK: - Common Method
    func configure() { }
    func addView() { }
    func layout() { }
    func binding() { }
    
    // MARK: - Keyboard Notification
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapToDismiss)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let keyboardAdjustableView
        else { return }

        UIView.animate(withDuration: duration) {
            keyboardAdjustableView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 28)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let keyboardAdjustableView
        else { return }

        UIView.animate(withDuration: duration) {
            keyboardAdjustableView.transform = .identity
        }
    }
    
    @objc
    func handleTapToDismiss() {
        view.endEditing(true)
    }
}

extension UIViewController {
    @objc var screenName: String {
        return String(describing: type(of: self))
    }
    
    @objc var screenClassName: String {
        return String(describing: type(of: self))
    }

    func trackScreenAppear() {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClassName
        ])
        
        Crashlytics.crashlytics().log("Entered screen: \(screenName)")
    }

    func trackScreenDuration(startTime: Date?) {
        guard let startTime else { return }
        let duration = Date().timeIntervalSince(startTime)
        Analytics.logEvent("screen_duration", parameters: [
            "screen_name": screenName,
            "duration": duration
        ])
    }
}
