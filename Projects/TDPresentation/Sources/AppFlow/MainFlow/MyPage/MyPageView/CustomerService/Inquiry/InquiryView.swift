import SnapKit
import TDDesign
import UIKit

final class InquiryView: BaseView {

    // MARK: - UI Components

    private(set) var scrollView = UIScrollView()

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private(set) var inquiryTypeView = InquiryTypeView()

    private(set) var contentTextView = TDFormTextView(
        title: "문의 내용",
        isRequired: true,
        maxCharacter: 500,
        placeholder: "문의하실 내용을 입력해주세요",
        maxHeight: 250
    )

    private(set) var formPhotoView = TDFormPhotoView(
        titleText: "사진 첨부",
        isRequired: false,
        maxCount: 5
    )

    private let noticeView = InquiryNoticeView().then {
        $0.addDescription("앱 사용중 불편하거나 궁금한점, 필요한 서비스 제안이 있다면 알려주세요. 작은 의견도 놓치지 않고 빠르게 답변드리겠습니다!")
        $0.addDescription("(서비스 운영과 무관한 내용은 답변이 어려울 수 있습니다.)")
    }

    let noticeSnackBarView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral700
        $0.layer.cornerRadius = 8
    }

    let noticeSnackBarLabel = TDLabel(
        labelText: "문의 유형 선택과 내용입력은 필수 입력이에요!",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.baseWhite
    )

    private(set) var buttonContainerView = UIView().then {
        $0.backgroundColor = TDColor.baseWhite
    }

    private(set) var submitButton = TDBaseButton(
        title: "등록",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )

    private let dummyView = UIView()

    // MARK: - Properties

    var noticeSnackBarBottomConstraint: Constraint?

    // MARK: - Lifecycle

    override func addview() {
        addSubview(scrollView)
        addSubview(noticeSnackBarView)
        addSubview(buttonContainerView)
        scrollView.addSubview(stackView)
        noticeSnackBarView.addSubview(noticeSnackBarLabel)
        buttonContainerView.addSubview(submitButton)

        stackView.addArrangedSubview(inquiryTypeView)
        stackView.addArrangedSubview(contentTextView)
        stackView.addArrangedSubview(formPhotoView)
        stackView.addArrangedSubview(noticeView)
        stackView.addArrangedSubview(dummyView)
    }

    override func configure() {
        backgroundColor = TDColor.baseWhite
        submitButton.isEnabled = false

        stackView.setCustomSpacing(36, after: inquiryTypeView)
        stackView.setCustomSpacing(52, after: contentTextView)
        stackView.setCustomSpacing(36, after: formPhotoView)
    }

    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(scrollView.snp.width).offset(-40)
        }

        noticeSnackBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            noticeSnackBarBottomConstraint = make.bottom.equalTo(buttonContainerView.snp.top).offset(50).constraint
        }

        noticeSnackBarLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }

        buttonContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }

        submitButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }

        contentTextView.snp.makeConstraints { make in
            make.height.equalTo(282)
        }

        formPhotoView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }

        dummyView.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
    }
}
