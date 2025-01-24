//
//  TDSnackbar.swift
//  toduck
//
//  Created by 신효성 on 9/19/24.
//

import UIKit

public final class TDToast: UIView {
	let toastView: TDToastView

	public convenience init(toastType: TDToastType, titleText: String, contentText: String) {
		self.init(
			foregroundColor: toastType.color, tomatoImage: toastType.tomato,
			titleText: titleText, contentText: contentText)
	}

	public init(
		foregroundColor: UIColor, tomatoImage: UIImage, titleText: String,
		contentText: String
	) {
		toastView = TDToastView(
			foregroundColor: foregroundColor, tomatoImage: tomatoImage,
			titleText: titleText,
			contentText: contentText)
		super.init(frame: .zero)
		configure()
		layout()
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		backgroundColor = .clear

		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.1
		layer.shadowOffset = CGSize(width: 0, height: 4)
		layer.shadowRadius = 10
		layer.masksToBounds = false
		addSubview(toastView)
	}

	private func layout() {
		toastView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
}

final class TDToastView: UIView {

	// MARK: - Properties
	private let foregroundColor: UIColor
	private let titleText: String
	private let contentText: String
	private let sideDumpView: UIView = .init()
	private let tomato: UIImageView
	private let sideColor: UIView = .init()
	private let title = TDLabel(toduckFont: .boldBody2)
	private let content = TDLabel(
		toduckFont: .regularBody2, toduckColor: TDColor.Neutral.neutral800)
	private let stackY = UIStackView().then {
		$0.axis = .vertical
		$0.spacing = 2
	}

	// MARK: - Initialize
	public init(
		frame: CGRect = .zero, foregroundColor: UIColor, tomatoImage: UIImage,
		titleText: String,
		contentText: String
	) {
		self.foregroundColor = foregroundColor
		self.titleText = titleText
		self.contentText = contentText
		self.tomato = UIImageView(image: tomatoImage)
		super.init(frame: frame)
		configure()
		addSubView()
		layout()
	}

	@available(*, unavailable)
	public required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Methods
	private func layout() {
		snp.updateConstraints {
			$0.height.equalTo(69)
		}
		sideDumpView.snp.makeConstraints {
			$0.leading.top.bottom.equalToSuperview()
			$0.width.equalTo(8)
		}

		tomato.snp.makeConstraints {
			$0.leading.equalTo(sideDumpView.snp.trailing).offset(16)
			$0.centerY.equalToSuperview()
			$0.size.equalTo(24)
		}

		stackY.snp.makeConstraints {
			$0.leading.equalTo(tomato.snp.trailing).offset(12)
			$0.trailing.equalToSuperview().inset(12)
			$0.centerY.equalToSuperview()
		}
	}

	private func configure() {
		layer.cornerRadius = 8
		backgroundColor = .white
		clipsToBounds = true

		sideDumpView.backgroundColor = foregroundColor

		title.setColor(foregroundColor)
		title.setText(titleText)

		content.setText(contentText)

		sideColor.backgroundColor = foregroundColor
	}

	private func addSubView() {
		addSubview(sideDumpView)
		addSubview(tomato)
		addSubview(stackY)

		stackY.addArrangedSubview(title)
		stackY.addArrangedSubview(content)
	}
}

extension TDToast {
	public enum TDToastType {
		case orange
		case green

		var color: UIColor {
			switch self {
			case .green:
				return TDColor.Semantic.success
			case .orange:
				return TDColor.Primary.primary500
			}
		}
		var tomato: UIImage {
			switch self {
			case .green:
				return TDImage.Tomato.green
			case .orange:
				return TDImage.Tomato.orange
			}
		}
	}
}
