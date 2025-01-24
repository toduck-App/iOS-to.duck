//
//  TDFocusTimeItme.swift
//  TDDesign
//
//  Created by 신효성 on 12/30/24.
//

import TDDomain
import UIKit

public final class TDFocusCountStack: UIStackView {

    ///현재 개수
	public var count: Int = 0 {
		didSet {
			updateStack()
		}
	}
    
    ///최대 개수
	public var maxCount: Int = 4 {
		didSet {
			updateStack()
		}
	}

    ///테마
	public var theme: TDTimerTheme = .Bboduck {
		didSet {
			self.arrangedSubviews.forEach { tomato in
				if tomato is TDFocusCountItem {
					(tomato as! TDFocusCountItem).theme = self.theme
				}
			}
		}
	}

	//MARK: - Initializer
	public init() {
		super.init(frame: .zero)
		self.axis = .horizontal
		self.spacing = 4
		self.distribution = .fillEqually
		updateStack()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func updateStack() {
		guard count >= 0 && count <= maxCount else { return }

		// 필요한 만큼 아이템 추가 또는 제거
		while arrangedSubviews.count < maxCount {
			addArrangedSubview(TDFocusCountItem(theme))
		}

		while arrangedSubviews.count > maxCount {
			if let lastView = arrangedSubviews.last {
				removeArrangedSubview(lastView)
				lastView.removeFromSuperview()
			}
		}

		// 스택 상태 업데이트
		for (index, view) in arrangedSubviews.enumerated() {
			guard let item = view as? TDFocusCountItem else { continue }
			item.isStacked = index < count
		}
	}
}

final class TDFocusCountItem: UIView {
	private let size: CGFloat = 16

	private let tomatoView = UIImageView(image: TDImage.Tomato.tomato)

	public var isStacked: Bool {
		didSet {
			if isStacked {
				if !subviews.contains(tomatoView) {
					addSubview(tomatoView)
				}
			} else {
				tomatoView.removeFromSuperview()
			}
		}
	}

	public var theme: TDTimerTheme {
		didSet {
			switch theme {
			case .Bboduck:
				backgroundColor = TDColor.Primary.primary25
				layer.borderColor = TDColor.Primary.primary200.cgColor
			case .Simple:
				backgroundColor = TDColor.Neutral.neutral200
				layer.borderColor = UIColor.clear.cgColor
			}
		}
	}

	public init(_ theme: TDTimerTheme, isStacked: Bool = false) {
		self.theme = theme
		self.isStacked = isStacked
		super.init(frame: .zero)
		configure()
		layout()
	}

	required init?(coder: NSCoder) {
		self.theme = .Bboduck
		self.isStacked = false
		super.init(coder: coder)
		configure()
		layout()
	}

	func configure() {
		layer.borderWidth = 1
		layer.borderColor = TDColor.Primary.primary200.cgColor
		layer.cornerRadius = size / 2
		backgroundColor = TDColor.Primary.primary25
	}

	func layout() {
		snp.makeConstraints { make in
			make.size.equalTo(self.size)
		}

		tomatoView.snp.makeConstraints { make in
			make.size.equalTo(self.size)
		}
	}
}
