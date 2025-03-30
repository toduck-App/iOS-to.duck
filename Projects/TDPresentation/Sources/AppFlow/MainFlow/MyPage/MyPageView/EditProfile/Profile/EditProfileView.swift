//
//  EditProfileView.swift
//  TDPresentation
//
//  Created by 정지용 on 1/23/25.
//

import UIKit
import TDDesign

protocol EditProfileDelegate: AnyObject {
    func editProfileView(_ view: EditProfileView, text: String, didUpdateCondition isConditionMet: Bool)
}

final class EditProfileView: BaseView {
    weak var delegate: EditProfileDelegate?
    private let profileImageView = TDImageView()
    let nicknameField = TDFormTextField(
        title: "닉네임",
        isRequired: false,
        maxCharacter: LayoutConstants.nicknameMaxLength,
        placeholder: "닉네임을 작성해주세요"
    )
    
    override func addview() {
        nicknameField.delegate = self
        [profileImageView, nicknameField].forEach(addSubview)
    }
    
    override func layout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(LayoutConstants.imageViewSize)
        }
        
        nicknameField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(LayoutConstants.commonPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.commonPadding)
            $0.height.equalTo(LayoutConstants.nicknameFieldHeight)
        }
    }
}

extension EditProfileView: TDFormTextFieldDelegate {
    func tdTextField(_ textField: TDFormTextField, didChangeText text: String) {
        let condition = text.count > 0 && text.count <= LayoutConstants.nicknameMaxLength
        delegate?.editProfileView(self, text: text, didUpdateCondition: condition)
    }
}

private extension EditProfileView {
    enum LayoutConstants {
        static let topPadding: CGFloat = 42.5
        static let imageViewSize: CGFloat = 120
        static let nicknameLabelTopPadding: CGFloat = 20
        static let commonPadding: CGFloat = 16
        static let nicknameMaxLength: Int = 8
        static let nicknameFieldHeight: Int = 84
    }
}
