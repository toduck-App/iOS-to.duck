import UIKit
import TDDesign
import SnapKit
import Then

final class ScheduleListView: BaseView {
    let segmentedControl = TDSegmentedControl(
        items: ["전체", "주제별"]
    )
    
    override func addview() {
        addSubview(segmentedControl)
    }
    
    override func layout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
