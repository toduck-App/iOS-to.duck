// MARK: – BaseViewController+CommonAlert.swift

import SnapKit
import TDDesign
import Then
import UIKit

extension BaseViewController where BaseViewController: TDPopupPresentable {
    /// 공통 Alert 띄우기 (취소·확인 버튼)
    /// - Parameters:
    ///   - title: 제목 (nil이면 숨김)
    ///   - message: 본문
    ///   - image: 상단 이미지 (이미지 사이즈에 맞춰서 자동 조절)
    ///   - cancelTitle: 취소 버튼 타이틀
    ///   - confirmTitle: 확인 버튼 타이틀
    ///   - onCancel: 취소 버튼 눌렀을 때 실행
    ///   - onConfirm: 확인 버튼 눌렀을 때 실행
    func showCommonAlert(
        title: String? = nil,
        message: String,
        image: UIImage = TDImage.errorAlert,
        cancelTitle: String = "취소",
        confirmTitle: String = "확인",
        onCancel: (() -> Void)? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        let alertVC = TDCommonAlertViewController()
        alertVC.configure(
            title: title,
            message: message,
            image: image,
            cancelTitle: cancelTitle,
            confirmTitle: confirmTitle,
            onCancel: onCancel,
            onConfirm: onConfirm
        )
        presentPopup(with: alertVC)
    }
}

// MARK: – TDCommonAlertViewController.swift

import SnapKit
import TDDesign
import Then
import UIKit

final class TDCommonAlertViewController: TDPopupViewController<TDCommonAlertView> {
    private var onCancel: (() -> Void)?
    private var onConfirm: (() -> Void)?

    override func configure() {
        super.configure()
        setupButtonActions()
    }

    func configure(
        title: String?,
        message: String,
        image: UIImage,
        cancelTitle: String,
        confirmTitle: String,
        onCancel: (() -> Void)?,
        onConfirm: (() -> Void)?
    ) {
        if let title {
            popupContentView.titleLabel.setText(title)
            popupContentView.titleLabel.isHidden = false
        } else {
            popupContentView.titleLabel.isHidden = true
        }
        popupContentView.descriptionLabel.setText(message)
        popupContentView.errorImageView.image = image

        popupContentView.cancelButton.setTitle(cancelTitle, for: .normal)
        popupContentView.confirmButton.setTitle(confirmTitle, for: .normal)

        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    private func setupButtonActions() {
        popupContentView.cancelButton.addAction(
            UIAction { [weak self] _ in
                self?.dismiss(animated: true) {
                    self?.onCancel?()
                }
            },
            for: .touchUpInside
        )
        popupContentView.confirmButton.addAction(
            UIAction { [weak self] _ in
                self?.dismiss(animated: true) {
                    self?.onConfirm?()
                }
            },
            for: .touchUpInside
        )
    }
}

// MARK: – TDCommonAlertView.swift

import SnapKit
import TDDesign
import Then
import UIKit

final class TDCommonAlertView: BaseView {
    let containerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.layer.cornerRadius = 24
    }

    let errorImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.errorAlert
    }

    let titleLabel = TDLabel(
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let descriptionLabel = TDLabel(
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    let cancelButton = TDBaseButton(
        title: "취소",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral700,
        radius: 12,
        font: TDFont.boldBody1.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    
    let confirmButton = TDBaseButton(
        title: "확인",
        backgroundColor: TDColor.Semantic.error,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldBody1.font
    )
    
    private let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }

    override func addview() {
        addSubview(containerView)
        containerView.addSubview(errorImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(buttonStack)
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(confirmButton)
    }

    override func layout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        errorImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(errorImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
