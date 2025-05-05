import TDDesign
import Then
import UIKit

final class SocialSelectRoutineView: BaseView {
    private let titleIcon = UIImageView().then {
        $0.image = TDImage.Direction.curvedArrowMedium
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = TDLabel(
        labelText: "공유할 루틴을 선택해주세요",
        toduckFont: .boldHeader4,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private(set) var routineTableView = UITableView().then {
        $0.backgroundColor = TDColor.baseWhite
        $0.separatorStyle = .none
    }
    
    let emptyView = UIView()
    private let emptyImageView = UIImageView(image: TDImage.noEvent)
    private let emptyLabel = TDLabel(
        labelText: "공유할 루틴이 없어요",
        toduckFont: TDFont.boldBody1,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    override func addview() {
        addSubview(titleIcon)
        addSubview(titleLabel)
        addSubview(routineTableView)
        addSubview(emptyView)
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLabel)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        routineTableView.backgroundColor = TDColor.baseWhite
    }
    
    override func layout() {
        titleIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleIcon)
            $0.leading.equalTo(titleIcon.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        routineTableView.snp.makeConstraints {
            $0.top.equalTo(titleIcon.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(routineTableView)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(96)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}
