import SnapKit
import TDDesign
import UIKit

final class SocialCreateView: BaseView {
    private(set) var socialSelectCategoryView = SocialSelectCategoryView()
    private(set) var socialSelectRoutineView = SocialSelectRoutineView()
    private(set) var socialTextFieldView = SocialTextFieldView(title: "내용", isRequired: true, maxCharacter: 500)
    private(set) var socialAddPhotoView = SocialAddPhotoView()
    
    let cautionView = SocialCautionView(title: "이런 글은 안돼요!").then {
        $0.addDescription("욕설, 비방 등을 포함한 타인에게 불쾌감을 주는 글")
        $0.addDescription("광고 또는 홍보성 게시글")
        $0.addDescription("실명, 주민등록번호, 주소 등 개인정보가 포함된 글")
        $0.addDescription("타인의 저작권을 침해한 글")
    }
    
    override func addview() {
        addSubview(socialSelectCategoryView)
        addSubview(socialSelectRoutineView)
        addSubview(socialTextFieldView)
        addSubview(socialAddPhotoView)
        addSubview(cautionView)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
    }
    
    override func layout() {
        socialSelectCategoryView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.height.equalTo(68)
        }
        
        socialSelectRoutineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(socialSelectCategoryView.snp.bottom).offset(20)
            make.height.equalTo(80)
        }
        
        socialTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(socialSelectRoutineView.snp.bottom).offset(20)
            make.height.equalTo(140)
        }
        
        socialAddPhotoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(socialTextFieldView.snp.bottom).offset(20)
            make.height.equalTo(160)
        }
        
        cautionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(138)
        }
    }
}
