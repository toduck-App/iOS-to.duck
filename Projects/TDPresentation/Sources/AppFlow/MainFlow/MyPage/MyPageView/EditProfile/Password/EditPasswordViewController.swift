//
//  EditPasswordViewController.swift
//  TDPresentation
//
//  Created by 정지용 on 1/23/25.
//

import UIKit

final class EditPasswordViewController: BaseViewController<EditPasswordView> {
    weak var coordinator: EditPasswordCoordinator?
    
    override func configure() {
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "비밀번호 수정",
            leftButtonAction: UIAction { _ in
                self.coordinator?.popViewController()
            },
            rightButtonTitle: "저장",
            rightButtonAction: UIAction { _ in
                // TODO: 저장 기능 연동
                self.coordinator?.popViewController()
            }
        )
    }
}
