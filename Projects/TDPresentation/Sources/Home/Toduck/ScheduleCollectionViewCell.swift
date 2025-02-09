import UIKit
import TDDesign
import SnapKit
import Then

final class ScheduleCollectionViewCell: UICollectionViewCell {
    let eventDetailView = EventDetailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(eventDetailView)
        eventDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
