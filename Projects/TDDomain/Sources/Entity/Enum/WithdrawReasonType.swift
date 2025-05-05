public enum WithdrawReasonType: String {
    case hardToUse = "HARD_TO_USE"
    case missingFeatures = "NO_FEATURES"
    case frequentErrors = "MANY_ERRORS"
    case foundBetterApp = "BETTER_APP"
    case rejoinWithNewAccount = "SWITCH_ACCOUNT"
    case other = "OTHER"
    
    public var description: String {
        switch self {
        case .hardToUse:
            return "사용 방법이 어려워요"
        case .missingFeatures:
            return "원하는 기능이 없어요"
        case .frequentErrors:
            return "오류가 자주 발생해요"
        case .foundBetterApp:
            return "더 좋은 어플이 있어요"
        case .rejoinWithNewAccount:
            return "다른 계정으로 다시 가입하고 싶어요"
        case .other:
            return "기타"
        }
    }
    
    public var placeholder: String {
        switch self {
        case .hardToUse:
            return """
            토덕 어플 사용 중 어떤 어려움을 겪으셨는지 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .missingFeatures:
            return """
            토덕 어플에 추가되었으면 하는 기능을 자유롭게 이야기 해 주세요.
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .frequentErrors:
            return """
            토덕 어플 사용 중 어떤 어려움을 겪으셨는지 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .foundBetterApp:
            return """
            토덕 어플보다 더 좋은 기능을 가진 어플이 있다면 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .rejoinWithNewAccount:
            return """
            다른 계정으로 재가입을 원하시는 이유를 알려주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        case .other:
            return """
            토덕의 발전을 위해 아쉬운 점이 있다면, 편하게 작성해주세요. 
            토덕은 언제나 여러분의 의견을 기다립니다. (130자 제한)
            """
        }
    }
}
