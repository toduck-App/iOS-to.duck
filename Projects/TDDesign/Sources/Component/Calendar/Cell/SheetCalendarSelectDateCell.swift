import FSCalendar
import SnapKit
import Then

public final class SheetCalendarSelectDateCell: FSCalendarCell {
    public let todayDotView = UIView().then {
        $0.backgroundColor = TDColor.Primary.primary500
        $0.layer.cornerRadius = 2
        $0.isHidden = true
    }
    public let circleBackImageView = UIImageView()
    public let leftRectBackImageView = UIImageView()
    public let rightRectBackImageView = UIImageView()

    public override init(frame: CGRect) {
		super.init(frame: frame)

		setConfigure()
		setConstraints()
		settingImageView()
	}

    @available(*, unavailable)
    public required init(coder: NSCoder) {
		super.init(coder: coder)

		setConfigure()
		setConstraints()
		settingImageView()
	}

	private func setConfigure() {
		contentView.insertSubview(circleBackImageView, at: 0)
		contentView.insertSubview(leftRectBackImageView, at: 0)
		contentView.insertSubview(rightRectBackImageView, at: 0)
        contentView.addSubview(todayDotView)
	}
    
	private func setConstraints() {
        todayDotView.snp.makeConstraints {
            $0.size.equalTo(4)
            $0.top.equalTo(contentView).inset(1)
            $0.trailing.equalTo(contentView).inset(4)
        }
        
		titleLabel.snp.makeConstraints {
			$0.center.equalTo(contentView)
		}

		leftRectBackImageView.snp.makeConstraints {
			$0.leading.equalTo(contentView)
			$0.trailing.equalTo(contentView.snp.centerX)
			$0.height.equalTo(46)
			$0.centerY.equalTo(contentView)
		}

		circleBackImageView.snp.makeConstraints {
			$0.center.equalTo(contentView)
			$0.size.equalTo(46)
		}

		rightRectBackImageView.snp.makeConstraints {
			$0.leading.equalTo(contentView.snp.centerX)
			$0.trailing.equalTo(contentView)
			$0.height.equalTo(46)
			$0.centerY.equalTo(contentView)
		}
	}

	private func settingImageView() {
		circleBackImageView.clipsToBounds = true
		circleBackImageView.layer.cornerRadius = 23

		[circleBackImageView, leftRectBackImageView, rightRectBackImageView].forEach {
			$0.backgroundColor = TDColor.Primary.primary50
		}
	}
    
    public func markAsToday(_ isToday: Bool) {
        todayDotView.isHidden = !isToday
    }
}

extension SheetCalendarSelectDateCell {
    public func updateBackImage(_ dateType: SelectedDateType) {
		switch dateType {
		case .singleDate:
			leftRectBackImageView.isHidden = true
			rightRectBackImageView.isHidden = true
			circleBackImageView.isHidden = false
			circleBackImageView.backgroundColor = TDColor.Primary.primary100

		case .firstDate:
			leftRectBackImageView.isHidden = true
			rightRectBackImageView.isHidden = false
			circleBackImageView.isHidden = false
			circleBackImageView.backgroundColor = TDColor.Primary.primary100

		case .middleDate:
			leftRectBackImageView.isHidden = false
			rightRectBackImageView.isHidden = false
			circleBackImageView.isHidden = true

		case .lastDate:
			rightRectBackImageView.isHidden = true
			leftRectBackImageView.isHidden = false
			circleBackImageView.isHidden = false
			circleBackImageView.backgroundColor = TDColor.Primary.primary100

		case .notSelected:
			circleBackImageView.isHidden = true
			leftRectBackImageView.isHidden = true
			rightRectBackImageView.isHidden = true
		}
	}
}
