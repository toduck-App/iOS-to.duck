
public struct TDTimerSetting {
    public var focusDuration: Int
    public var focusCount: Int
    public var restDuration: Int

    public init(focusDuration: Int, foucsCount: Int, restDuration: Int) {
        self.focusDuration = focusDuration
        focusCount = foucsCount
        self.restDuration = restDuration
    }

    /// 초기값 설정
    public init() {
        focusDuration = 25
        focusCount = 4
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
