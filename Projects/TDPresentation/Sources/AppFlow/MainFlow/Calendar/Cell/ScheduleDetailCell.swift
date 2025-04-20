import UIKit
import TDDomain
import TDDesign
import SnapKit
import Then

final class ScheduleDetailCell: UITableViewCell {
    private let eventDetailView = EventDetailView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(eventDetailView)
        eventDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }

    func configure(
        with schedule: Schedule,
        checkAction: @escaping () -> Void
    ) {
        eventDetailView.configureCell(
            color: schedule.categoryColor,
            title: schedule.title,
            time: schedule.time,
            category: schedule.categoryIcon,
            isFinished: schedule.isFinished,
            place: schedule.place
        )
        eventDetailView.configureButtonAction {
            checkAction()
        }
    }
}
