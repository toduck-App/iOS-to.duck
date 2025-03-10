import UIKit
import SnapKit
import Then

public final class CalendarHeaderStackView: UIStackView {
    private let titleLabel = TDLabel(
        labelText: "2024년 8월",
        toduckFont: TDFont.boldHeader4,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral700
    )
    public let pickerButton: PickerButton
    
    public init(type: CalendarType) {
        self.pickerButton = PickerButton(type: type == .sheet ? .sheet : .toduck)
        super.init(frame: .zero)
        commonInit(type: type)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(type: CalendarType) {
        axis = .horizontal
        spacing = type == .sheet ? 4 : 8

        switch type {
        case .toduck, .diary:
            setupDefaultHeader()
        case .sheet:
            setupSheetHeader()
        }
    }
    
    private func setupDefaultHeader() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(pickerButton)
    }
    
    private func setupSheetHeader() {
        let calendarImage = UIImageView(image: TDImage.Calendar.top3Medium)
        let label = TDLabel(
            toduckFont: TDFont.mediumHeader5,
            alignment: .center,
            toduckColor: TDColor.Neutral.neutral600
        )

        addArrangedSubview(calendarImage)
        addArrangedSubview(label)
        addArrangedSubview(pickerButton)
    }
}
