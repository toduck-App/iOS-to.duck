import UIKit

final class PickerButton: UIButton {
    private var datePicker = UIDatePicker()
    var dateSelectedHandler: ((Date) -> Void)?
    
    init(type: CalendarType) {
        super.init(frame: .zero)
        
        switch type {
        case .toduck, .diary:
            self.setImage(TDImage.Direction.rightMedium.withTintColor(TDColor.Neutral.neutral700), for: .normal)
        case .sheet:
            self.setImage(TDImage.Direction.rightSmall, for: .normal)
        }
        
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
        
        datePicker = UIDatePicker()
        if #available(iOS 17.4, *) {
            datePicker.datePickerMode = .yearAndMonth
        } else {
            datePicker.datePickerMode = .date
        }
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 0, y: 50, width: alert.view.bounds.width, height: 250)
        datePicker.locale = Locale(identifier: "ko_KR")
        
        alert.view.addSubview(datePicker)
        
        let selectAction = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            if let selectedDate = self?.datePicker.date {
                self?.dateSelectedHandler?(selectedDate)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
