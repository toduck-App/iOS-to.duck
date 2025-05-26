import UIKit
import Then

public final class PickerImageView: UIImageView {
    init(type: CalendarType) {
        super.init(frame: .zero)
        
        let image: UIImage?
        switch type {
        case .toduck, .diary, .focus:
            image = TDImage.Direction.downMedium.withTintColor(TDColor.Neutral.neutral600)
        case .sheet:
            image = TDImage.Direction.rightSmall
        }
        self.image = image
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
