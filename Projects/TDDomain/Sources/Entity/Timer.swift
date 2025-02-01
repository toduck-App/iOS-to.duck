//
//  Timer.swift
//  TDDomain
//
//  Created by 신효성 on 12/30/24.
//

public struct TDTimerSetting {
	public var focusDuration: Int
	public var focusCount: Int
	public var restDuration: Int

	public init(focusDuration: Int, foucsCount: Int, restDuration: Int) {
		self.focusDuration = focusDuration
		self.focusCount = foucsCount
		self.restDuration = restDuration
	}

	public func toMiniutes() -> Int {
		return focusDuration * 60
	}
}

//MARK: - Dummy Extension
extension TDTimerSetting {
	public static func dummy() -> TDTimerSetting {
		return TDTimerSetting(focusDuration: 30, foucsCount: 4, restDuration: 10)
	}
}
