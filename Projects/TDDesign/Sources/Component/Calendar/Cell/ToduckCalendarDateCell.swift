import FSCalendar
import SnapKit
import Then

public final class ToduckCalendarDateCell: FSCalendarCell {
    public let todayDotView = UIView().then {
        $0.backgroundColor = TDColor.Primary.primary500
        $0.layer.cornerRadius = 2
        $0.isHidden = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setConstraints()
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpViews()
        setConstraints()
    }

    private func setUpViews() {
        contentView.addSubview(todayDotView)
    }

    private func setConstraints() {
        todayDotView.snp.makeConstraints {
            $0.size.equalTo(4)
            $0.top.equalTo(contentView).inset(4)
            $0.trailing.equalTo(contentView).inset(7)
        }
    }
    
    public func markAsToday(_ isToday: Bool) {
        todayDotView.isHidden = !isToday
    }
}
