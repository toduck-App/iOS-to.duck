import Foundation

public enum Constant {
    public static let toduckDesignBundle = "to.duck.toduck.design"
    public static let toduckAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    public static let appStoreURL = URL(string: "itms-apps://apps.apple.com/app/id/6502951629")!
}
