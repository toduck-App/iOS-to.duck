import SnapKit
import TDDesign
import UIKit

final class SocialCreateView: BaseView {
    private(set) var socialSelectCategoryView = SocialSelectCategoryView()
    private(set) var socialSelectRoutineView = SocialSelectRoutineView()
    
    let cautionView = SocialCautionView(title: "이런 글은 안돼요!").then {
        $0.addDescription("욕설, 비방 등을 포함한 타인에게 불쾌감을 주는 글")
        $0.addDescription("광고 또는 홍보성 게시글")
        $0.addDescription("실명, 주민등록번호, 주소 등 개인정보가 포함된 글")
        $0.addDescription("타인의 저작권을 침해한 글")
    }
    
    
    override func addview() {
        addSubview(socialSelectCategoryView)
        addSubview(socialSelectRoutineView)
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
            make.top.equalTo(socialSelectCategoryView.snp.bottom).offset(36)
            make.height.equalTo(80)
        }
        
        cautionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-21)
            make.height.equalTo(138)
        }
    }
}

private extension SocialCreateView {
    
}
