import ProjectDescription

public enum External: String {
    case Then
    case Lottie
    case FSCalendar
    case Kingfisher
    case SnapKit
    case FittedSheets
}

extension TargetDependency {
    public static func external(dependency: External)-> TargetDependency {
        .external(name: dependency.rawValue, condition: .when([.ios]))
    }
}
