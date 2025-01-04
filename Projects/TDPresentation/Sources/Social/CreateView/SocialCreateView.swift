import SnapKit
import TDDesign
import UIKit

final class SocialCreateView: BaseView {
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    
    /// 기존 `contentView` 대신 stackView 사용
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private(set) var socialSelectCategoryView = SocialSelectCategoryView()
    private(set) var socialSelectRoutineView = SocialRoutineInputView()
    private(set) var titleTextFieldView = TDFormTextField(
        title: "제목",
        isRequired: true,
        maxCharacter: 16,
        placeholder: "글의 제목을 작성해주세요."
    )
    private(set) var descriptionTextFieldView = TDFormTextView(
        title: "내용",
        isRequired: true,
        maxCharacter: 500,
        placeholder: "자유롭게 내용을 작성해 주세요."
    )
    private(set) var socialAddPhotoView = SocialAddPhotoView()
    
    private let noticeView = SocialCautionView(style: .notice, title: "확인해주세요!").then {
        $0.addDescription("공유한 루틴은 이후 삭제/비공개 처리에도 영향을 받지 않아요.")
        $0.addDescription("숨기고 싶은 공유 루틴이 있다면, 게시물 삭제를 이용해주세요.")
    }
    
    private let warningView = SocialCautionView(style: .warning, title: "이런 글은 안돼요!").then {
        $0.addDescription("욕설, 비방 등을 포함한 타인에게 불쾌감을 주는 글")
        $0.addDescription("광고 또는 홍보성 게시글")
        $0.addDescription("실명, 주민등록번호, 주소 등 개인정보가 포함된 글")
        $0.addDescription("타인의 저작권을 침해한 글")
    }
    
    // MARK: - Lifecycle
    
    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(socialSelectCategoryView)
        stackView.addArrangedSubview(socialSelectRoutineView)
        stackView.addArrangedSubview(titleTextFieldView)
        stackView.addArrangedSubview(descriptionTextFieldView)
        stackView.addArrangedSubview(socialAddPhotoView)
        stackView.addArrangedSubview(noticeView)
        stackView.addArrangedSubview(warningView)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        socialSelectCategoryView.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
        socialSelectRoutineView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        titleTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(84)
        }
        descriptionTextFieldView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        socialAddPhotoView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }
        noticeView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        warningView.snp.makeConstraints { make in
            make.height.equalTo(138)
        }
    }
}
