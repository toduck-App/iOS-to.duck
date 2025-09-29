import Foundation

public enum Constant {
    public static let toduckDesignBundle = "to.duck.toduck.design"
    public static let toduckAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
}
