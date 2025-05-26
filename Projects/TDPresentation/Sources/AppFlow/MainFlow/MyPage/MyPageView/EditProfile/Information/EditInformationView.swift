import UIKit
import TDDesign

final class EditInformationView: BaseView {
    private let nameField = TDTextField(
        placeholder: "이름을 입력해주세요",
        labelText: "이름"
    )
    
    private let phoneNumberField = TDTextField(
        placeholder: "전화번호를 입력해주세요",
        labelText: "휴대폰번호"
    )
    
    private let noticeLabel: TDLabel = {
        let label = TDLabel(
            toduckFont: .regularCaption2,
            toduckColor: TDColor.Neutral.neutral700
        )
        label.numberOfLines = 0
        label.setText("""
        ㆍ 이동통신사에 본인 명의로 가입되어 있는지 확인해주세요.
        ㆍ 개명하신 경우 다시 본인 인증하면 자동으로 이름이 변경돼요.
        """)
        label.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        return label
    }()
     
    override func addview() {
        [nameField, phoneNumberField, noticeLabel].forEach(addSubview)
    }
    
    override func layout() {
        nameField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        phoneNumberField.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(LayoutConstants.textFieldSpacing)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberField.snp.bottom).offset(LayoutConstants.noticePadding)
            $0.leading.equalToSuperview().offset(LayoutConstants.horizontalPadding)
        }
    }
}

private extension EditInformationView {
    enum LayoutConstants {
        static let horizontalPadding: CGFloat = 16
        static let textFieldSpacing: CGFloat = 18
        static let topPadding: CGFloat = 20
        static let noticePadding: CGFloat = 12
        static let labelLineHeightMultiple: CGFloat = 1.2
    }
}
