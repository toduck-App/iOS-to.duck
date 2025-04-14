import UIKit
import SnapKit
import Then
import TDDesign

final class TimeSlotGapCell: UITableViewCell {
    private let startLabel = TDLabel(
        toduckFont: .mediumCaption3,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    private let endLabel = TDLabel(
        toduckFont: .mediumCaption3,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    private let dotImageView = UIImageView(image: TDImage.Dot.verticalGap)
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        startLabel,
        dotImageView,
        endLabel
    ]).then {
        $0.axis = .vertical
        $0.alignment = .center
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(50)
        }
    }

    func configure(startHour: Int, endHour: Int) {
        let startPeriod = startHour >= 12 ? "PM" : "AM"
        let endPeriod = endHour >= 12 ? "PM" : "AM"
        
        let displayStartHour = (startHour % 12 == 0) ? 12 : (startHour % 12)
        let displayEndHour = (endHour % 12 == 0) ? 12 : (endHour % 12)

        if startHour == endHour {
            startLabel.text = "\(displayStartHour) \(startPeriod)"
            endLabel.text = nil
            dotImageView.isHidden = true
        } else {
            startLabel.text = "\(displayStartHour) \(startPeriod)"
            endLabel.text = "\(displayEndHour) \(endPeriod)"
            dotImageView.isHidden = false
        }
    }
}
