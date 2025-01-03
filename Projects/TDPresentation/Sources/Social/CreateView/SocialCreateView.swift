import SnapKit
import TDDesign
import UIKit

final class SocialCreateView: BaseView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private(set) var socialSelectCategoryView = SocialSelectCategoryView()
    private(set) var socialSelectRoutineView = SocialRoutineInputView()
    private(set) var titleTextFieldView = SocialTextFieldView(title: "제목", isRequired: true, maxCharacter: 16)
    private(set) var descriptionTextFieldView = SocialTextFieldView(title: "내용", isRequired: true, maxCharacter: 500)
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
    
    override func addview() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(socialSelectCategoryView)
        contentView.addSubview(socialSelectRoutineView)
        contentView.addSubview(descriptionTextFieldView)
        contentView.addSubview(socialAddPhotoView)
        contentView.addSubview(noticeView)
        contentView.addSubview(warningView)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
    }
    
    override func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        socialSelectCategoryView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(68)
        }
        
        socialSelectRoutineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(socialSelectCategoryView.snp.bottom).offset(20)
            make.height.equalTo(80)
        }
        
        descriptionTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(socialSelectRoutineView.snp.bottom).offset(20)
            make.height.equalTo(140)
        }
        
        socialAddPhotoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(descriptionTextFieldView.snp.bottom).offset(20)
            make.height.equalTo(160)
        }
        
        noticeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(socialAddPhotoView.snp.bottom).offset(20)
            make.height.equalTo(100)
        }
        
        warningView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(noticeView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(138)
        }
    }
}
