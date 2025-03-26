public struct TDTimerSetting {
    public var focusDuration: Int
    public var focusCountLimit: Int
    public var restDuration: Int

    public init(focusDuration: Int, focusCountLimit: Int, restDuration: Int) {
        self.focusDuration = focusDuration
        self.focusCountLimit = focusCountLimit
        self.restDuration = restDuration
    }

    /// 초기값 설정
    public init() {
        self.init(focusDuration: 25, focusCountLimit: 4, restDuration: 5)
    }

    public func toFocusDurationMinutes() -> Int {
        #if DEBUG
            return focusDuration / 10
        #else
            return focusDuration * 60
        #endif
    }

    public func toRestDurationMinutes() -> Int {
        #if DEBUG
            return restDuration
        #else
            return restDuration * 60
        #endif
    }
}

public extension TDTimerSetting {
    static let maxFocusCountLimit = 5
    static let minFocusCountLimit = 1
    
    static let maxFocusDuration = 60
    static let minFocusDuration = 5
    
    static let maxRestDuration = 10
    static let minRestDuration = 0
}
