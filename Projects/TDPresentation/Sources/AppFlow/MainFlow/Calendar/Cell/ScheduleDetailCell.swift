import UIKit
import TDDomain
import TDDesign
import SnapKit
import Then

final class ScheduleDetailCell: UITableViewCell {
    private let eventDetailView = TodoDetailView()

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
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
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
