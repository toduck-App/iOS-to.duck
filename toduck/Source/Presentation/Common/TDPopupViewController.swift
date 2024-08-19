import UIKit

class TDPopupViewController: UIViewController {
    var popupStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }

    var whiteBoard: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 28
    }

    var delegate: TDPopupPresentDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        addView()
        layout()
    }

    private func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true

        view.backgroundColor = .black.withAlphaComponent(0.5)

    }

    private func addView() {
        if let titleView = delegate?.popupTitleView(popupVc: self) {
            popupStackView.addArrangedSubview(titleView)
        }

        if let contentView = delegate?.popupContentView(popupVc: self) {
            popupStackView.addArrangedSubview(contentView)
        }

        if let bottomView = delegate?.popupBottomView(popupVc: self) {
            popupStackView.addArrangedSubview(bottomView)
        }

        view.addSubview(whiteBoard)
        whiteBoard.addSubview(popupStackView)
    }

    private func layout() {
        whiteBoard.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }

        popupStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(24)
        }
    }

    @objc func dismissPopup() {
        dismiss(animated: true, completion: nil)
    }
}

extension TDPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}