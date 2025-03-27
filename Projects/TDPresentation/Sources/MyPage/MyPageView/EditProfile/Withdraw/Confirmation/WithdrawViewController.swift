//
//  WithdrawViewController.swift
//  TDPresentation
//
//  Created by 정지용 on 1/23/25.
//

import UIKit

final class WithdrawViewController: BaseViewController<WithdrawView> {
    weak var coordinator: WithdrawCoordinator?

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

extension WithdrawViewController: WithdrawViewDelegate {
    func withdrawViewDidTapNextButton(_ withdrawView: WithdrawView) {
        coordinator?.didTapNextButton()
    }
}
