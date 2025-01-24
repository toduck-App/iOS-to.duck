import SnapKit
import TDDesign
import UIKit

final class BboduckTimerView: UIView {
	let backdropView = UIView().then {
		$0.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.58, alpha: 1.00)
	}

	let BboduckView = UIImageView().then {
		$0.image = TDImage.Tomato.tomato
		$0.contentMode = .scaleAspectFit
	}

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		addViews()
		layout()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		addViews()
		layout()
	}

	func addViews() {
		addSubview(backdropView)

	}

	func layout() {
		
	}
}
