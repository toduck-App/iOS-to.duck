import ProjectDescription

public enum External: String {
    case Alamofire
    case KakaoSDKCommon
    case KakaoSDKAuth
    case KakaoSDKUser
    case KakaoSDKShare
    case KakaoSDKTalk
    case Then
    case Lottie
    case FSCalendar
    case Kingfisher
    case SnapKit
    case Swinject
    case FittedSheets
    case FirebaseAnalytics
    case FirebaseCrashlytics
    case FirebaseMessaging
}

extension TargetDependency {
    public static func external(dependency: External)-> TargetDependency {
        .external(name: dependency.rawValue, condition: .when([.ios]))
    }
}
