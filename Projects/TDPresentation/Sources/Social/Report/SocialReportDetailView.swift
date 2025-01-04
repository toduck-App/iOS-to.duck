import SnapKit
import TDDesign
import Then
import UIKit

final class SocialReportDetailView: BaseView {
    private let reportImage = UIImageView().then {
        $0.image = TDImage.reportFillMedium
    }
    
    private let reasonLabel = TDLabel(toduckFont: .boldHeader4, toduckColor: TDColor.Neutral.neutral800)
    
    private let descriptionLabel = TDLabel(labelText: "해당 댓글 작성자 차단하기", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral600)
    
    private let socialTextField = TDFormTextView(
        title: "신고 내용",
        isRequired: false,
        maxCharacter: 300,
        placeholder: "신고 내용을 입력해주세요. (최대 300자)"
    )
    
    private let subDescriptionLabel = TDLabel(
        labelText: """
        다른 신고 항목에서 적당한 사유를 찾지 못하셨나요?
        신고 사유를 작성해주시면 운영진이 확인 후 적절한 조치를 취하도록 하겠습니다.
        """,
        toduckFont: .regularBody2,
        toduckColor: TDColor.Neutral.neutral600
    ).then {
        $0.numberOfLines = 0
    }

    private let checkBoxButton = TDCheckbox()
    
    private let captionLabel = TDLabel(
        labelText: "(마이페이지 > 차단 관리 > 게시글 미노출 사용자 관리에서 취소할 수 있습니다.)",
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    ).then {
        $0.numberOfLines = 0
    }
    
    private(set) var reportButton = TDButton(
        title: "신고하기",
        size: .large,
        foregroundColor: .white,
        backgroundColor: TDColor.Schedule.textPH
    )
    
    override func addview() {
        addSubview(reportImage)
        addSubview(subDescriptionLabel)
        addSubview(reasonLabel)
        addSubview(socialTextField)
        addSubview(descriptionLabel)
        addSubview(checkBoxButton)
        addSubview(captionLabel)
        addSubview(reportButton)
    }
    
    override func layout() {
        reportImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        
        reasonLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(reportImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        reportButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
    }
    
    func setReason(reason: ReportType) {
        reasonLabel.setText(reason.subTitle)
        switch reason {
        case .unrelated, .personalInfo, .advertisement, .inappropriate:
            setDefaultConstarints()
        case .custom:
            setCustomConstraints()
        }
    }
    
    private func setDefaultConstarints() {
        subDescriptionLabel.isHidden = true
        socialTextField.isHidden = true
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(reasonLabel.snp.bottom).offset(40)
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(52)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(descriptionLabel)
        }
    }
    
    private func setCustomConstraints() {
        subDescriptionLabel.isHidden = false
        socialTextField.isHidden = false
        subDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(reasonLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        socialTextField.snp.makeConstraints { make in
            make.top.equalTo(subDescriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(156)
        }
    
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(socialTextField.snp.bottom).offset(20)
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(52)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(descriptionLabel)
        }
    }
}
