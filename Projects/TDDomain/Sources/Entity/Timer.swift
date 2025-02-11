public struct TDTimerSetting {
    public var focusDuration: Int
    public var maxFocusCount: Int
    public var restDuration: Int

    public init(focusDuration: Int, maxFocusCount: Int, restDuration: Int) {
        self.focusDuration = focusDuration
        self.maxFocusCount = maxFocusCount
        self.restDuration = restDuration
    }

    /// 초기값 설정
    public init() {
        focusDuration = 25
        maxFocusCount = 4
        restDuration = 5
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
            return restDuration / 10
        #else
            return restDuration * 60
        #endif
    }
}
