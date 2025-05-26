import UIKit
import SnapKit
import Then

public protocol CalendarHeaderStackViewDelegate: AnyObject {
    func calendarHeader(_ header: CalendarHeaderStackView, didSelect date: Date)
}

public final class CalendarHeaderStackView: UIStackView {
    private let titleLabel = TDLabel(
        toduckFont: TDFont.boldHeader5,
        alignment: .center,
        toduckColor: TDColor.Neutral.neutral700
    )
    public let pickerImageView: PickerImageView
    public weak var delegate: CalendarHeaderStackViewDelegate?

    private lazy var datePicker = UIDatePicker().then {
        if #available(iOS 17.4, *) {
            $0.datePickerMode = .yearAndMonth
        } else {
            $0.datePickerMode = .date
        }
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }

    public init(type: CalendarType) {
        self.pickerImageView = PickerImageView(type: type == .sheet ? .sheet : .toduck)
        super.init(frame: .zero)
        titleLabel.setFont(type == .toduck ? .boldHeader4 : .boldHeader5)
        commonInit(type: type)
        setupTapGesture()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(type: CalendarType) {
        axis = .horizontal
        spacing = type == .sheet ? 4 : 8
        pickerImageView.snp.makeConstraints { $0.size.equalTo(18) }
        
        switch type {
        case .toduck, .focus, .diary:
            setupDefaultHeader()
        case .sheet:
            setupSheetHeader()
        }
    }

    private func setupDefaultHeader() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(pickerImageView)
    }

    private func setupSheetHeader() {
        let imageContainerView = UIView()
        let calendarImage = UIImageView(image: TDImage.Calendar.top3Medium)
        calendarImage.contentMode = .scaleAspectFit
        let label = TDLabel(
            toduckFont: TDFont.mediumHeader5,
            alignment: .center,
            toduckColor: TDColor.Neutral.neutral600
        )
        
        addArrangedSubview(imageContainerView)
        addArrangedSubview(label)
        addArrangedSubview(pickerImageView)
        imageContainerView.addSubview(calendarImage)
        imageContainerView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        calendarImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }

    @objc private func headerTapped() {
        let alert = UIAlertController(
            title: "원하는 년/월을 선택해주세요",
            message: "\n\n\n\n\n\n\n\n\n\n\n\n",
            preferredStyle: .actionSheet
        )

        datePicker.frame = CGRect(x: 0, y: 50, width: alert.view.bounds.width, height: 250)
        alert.view.addSubview(datePicker)

        let selectAction = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            guard let self else { return }
            delegate?.calendarHeader(self, didSelect: datePicker.date)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        if let topVC = getTopViewController() {
            topVC.present(alert, animated: true)
        }
    }

    private func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return nil
        }

        var topVC = rootVC
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
}
