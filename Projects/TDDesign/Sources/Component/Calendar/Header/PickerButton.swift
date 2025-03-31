import UIKit
import Then

public protocol PickerButtonDelegate: AnyObject {
    func pickerButton(_ pickerButton: PickerButton, didSelect date: Date)
}

public final class PickerButton: UIButton {
    private lazy var datePicker = UIDatePicker().then {
        if #available(iOS 17.4, *) {
            $0.datePickerMode = .yearAndMonth
        } else {
            $0.datePickerMode = .date
        }
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    public weak var delegate: PickerButtonDelegate?
    
    init(type: CalendarType) {
        super.init(frame: .zero)
        
        let image: UIImage?
        switch type {
        case .toduck, .diary:
            image = TDImage.Direction.downMedium.withTintColor(TDColor.Neutral.neutral500)
        case .sheet:
            image = TDImage.Direction.rightSmall
        }
        setImage(image, for: .normal)
        
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        addAction(UIAction { [weak self] _ in
            self?.showDatePicker()
        }, for: .touchUpInside)
    }
    
    private func showDatePicker() {
        let alert = UIAlertController(
            title: "원하는 년/월을 선택해주세요",
            message: "\n\n\n\n\n\n\n\n\n\n\n\n",
            preferredStyle: .actionSheet
        )
        
        datePicker.frame = CGRect(x: 0, y: 50, width: alert.view.bounds.width, height: 250)
        alert.view.addSubview(datePicker)
        
        let selectAction = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            guard let self else { return }
            delegate?.pickerButton(self, didSelect: datePicker.date)
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
