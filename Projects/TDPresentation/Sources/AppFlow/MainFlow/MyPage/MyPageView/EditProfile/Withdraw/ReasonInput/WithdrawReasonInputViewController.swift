//
//  WithdrawReasonInputViewController.swift
//  TDPresentation
//
//  Created by 정지용 on 1/29/25.
//

import TDDomain
import UIKit

final class WithdrawReasonInputViewController: BaseViewController<WithdrawReasonInputView> {
    weak var coordinator: WithdrawReasonInputCoordinator?

    override func configure() {
        layoutView.delegate = self
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "회원 탈퇴",
            leftButtonAction: UIAction { _ in
                self.coordinator?.popViewController()
            }
        )
    }
}

extension WithdrawReasonInputViewController: WithdrawReasonInputViewDelegate {
    func withdrawReasonInputViewDidTapNextButton(_ withdrawReasonInputView: WithdrawReasonInputView, selectedReason: WithdrawReasonType, reasonText: String) {
        if reasonText.isEmpty {
            showErrorAlert(titleError: "", errorMessage: "탈퇴 사유를 입력해주세요")
            return
        }
        coordinator?.didTapNextButton(type: selectedReason, reason: reasonText)
    }
}
