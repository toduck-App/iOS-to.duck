//
//  EditProfileViewController.swift
//  TDPresentation
//
//  Created by 정지용 on 1/23/25.
//

import UIKit

final class EditProfileViewController: BaseViewController<EditProfileView> {
    weak var coordinator: EditProfileCoordinator?
    
    override func configure() {
        layoutView.delegate = self
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "프로필 수정",
            leftButtonAction: UIAction { _ in
                self.coordinator?.finish(by: .pop)
            },
            rightButtonTitle: "저장",
            rightButtonAction: UIAction { _ in
                // TODO: 저장 기능 연동
                self.coordinator?.finish(by: .pop)
            }
        )
    }
}

extension EditProfileViewController: EditProfileDelegate {
    func editProfileView(_ view: EditProfileView, didUpdateCondition isConditionMet: Bool) {
        if isConditionMet {
            navigationController?.updateRightButtonState(to: .normal)
        } else {
            navigationController?.updateRightButtonState(to: .disabled)
        }
    }
}
