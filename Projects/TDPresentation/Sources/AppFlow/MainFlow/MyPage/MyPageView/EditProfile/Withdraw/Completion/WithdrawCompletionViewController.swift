//
//  WithdrawCompletionViewController.swift
//  TDPresentation
//
//  Created by 정지용 on 3/27/25.
//

import UIKit

final class WithdrawCompletionViewController: BaseViewController<WithdrawCompletionView> {
    weak var coordinator: WithdrawCompletionCoordinator?
    
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

extension WithdrawCompletionViewController: WithdrawCompletionViewDelegate {
    func WithdrawCompletionViewDidTapNextButton(_ view: WithdrawCompletionView) {
        coordinator?.popToRootViewController()
    }
}
