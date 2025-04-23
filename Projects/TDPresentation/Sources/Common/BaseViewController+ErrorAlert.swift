import SnapKit
import TDDesign
import Then
import UIKit

protocol ErrorAlertDisplayable: AnyObject {
    func showErrorAlert(errorMessage: String)
    func showErrorAlert(titleError: String, errorMessage: String, image: UIImage)
}

extension BaseViewController: TDPopupPresentable {
    func presentErrorPopup(
        titleError: String = "앗 !! 일시적인 오류가 발생했어요",
        errorMessage: String,
        image: UIImage = TDImage.errorAlert
    ) {
        let vc = TDErrorAlertViewController()
        vc.configureErrorMessage(
            titleError: titleError,
            errorMessage: errorMessage,
            image: image
        )
        presentPopup(with: vc)
    }
}

extension BaseViewController: ErrorAlertDisplayable where BaseViewController: TDPopupPresentable {
    func showErrorAlert(errorMessage: String) {
        presentErrorPopup(errorMessage: errorMessage)
    }
    
    func showErrorAlert(
        titleError: String = "앗 !! 일시적인 오류가 발생했어요",
        errorMessage: String,
        image: UIImage = TDImage.errorAlert
    ) {
        presentErrorPopup(
            titleError: titleError,
            errorMessage: errorMessage,
            image: image
        )
    }
}

final class TDErrorAlertViewController: TDPopupViewController<TDErrorAlertView> {
    override func configure() {
        super.configure()
        setupButtonAction()
    }
    
    func configureErrorMessage(titleError: String, errorMessage: String, image: UIImage = TDImage.errorAlert) {
        popupContentView.deleteLabel.setText(titleError)
        popupContentView.descriptionLabel.setText(errorMessage)
        popupContentView.errorImageView.image = image
    }

    private func setupButtonAction() {
        popupContentView.confirmButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }
}

final class TDErrorAlertView: BaseView {
    let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }
    
    let errorImageView = UIImageView().then {
        $0.image = TDImage.errorAlert
        $0.contentMode = .scaleAspectFit
    }

    let deleteLabel = TDLabel(
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    let descriptionLabel = TDLabel(
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let confirmButton = TDBaseButton(
        title: "확인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldBody1.font
    )
    
    override func addview() {
        addSubview(containerView)
        containerView.addSubview(errorImageView)
        containerView.addSubview(deleteLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(confirmButton)
    }
    
    override func layout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        errorImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(230)
            $0.height.equalTo(200)
        }
        
        deleteLabel.snp.makeConstraints {
            $0.top.equalTo(errorImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(deleteLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override func configure() {
        containerView.layer.cornerRadius = 24
    }
}
