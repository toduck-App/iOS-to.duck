//
//  TDToast+TYpe.swift
//  TDDesign
//
//  Created by 신효성 on 12/30/24.
//
import UIKit

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
