import Foundation

public final class TDTokenManager {
    public static let shared = TDTokenManager()
    
    // MARK: - Properties
    
    public private(set) var accessToken: String?
    public private(set) var refreshToken: String?
    public private(set) var refreshTokenExpiredAt: Date?
    public private(set) var pendingFCMToken: String?
    public private(set) var userId: Int?
    
    
    /// 오늘 이벤트 시트를 보여줘야 하는지 여부 (자정 기준으로 자동 리셋)
    public var shouldShowEventSheetToday: Bool {
        guard let last = UserDefaults.standard.object(forKey: UserDefaultsConstant.lastHiddenEventSheetDate) as? Date
        else { return true }

        return !Calendar.current.isDate(Date(), inSameDayAs: last)
    }

    /// “오늘은 그만보기” 눌렀을 때 호출
    public func markEventSheetHiddenForToday(now: Date = Date()) {
        let start = Calendar.current.startOfDay(for: now)
        UserDefaults.standard.set(start, forKey: UserDefaultsConstant.lastHiddenEventSheetDate)
    }
    
    public var username: String {
        return UserDefaults.standard.string(forKey: UserDefaultsConstant.username) ?? "뽀덕이"
    }

    public var isFirstLaunch: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsConstant.isFirstLaunch)
    }
    
    public var isFirstLogin: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsConstant.isFirstLogin)
    }
    
    // MARK: - Initializer
    
    private init() { }
    
    // MARK: - Keychain I/O
    
    public func loadTokenFromKC() async throws {
        let (accessToken, refreshToken, refreshTokenExpiredAtString, userId) = try await loadTokenStringsFromKeychain()
        let refreshTokenExpiredAt = try await validateRefreshToken(expiredAtString: refreshTokenExpiredAtString)
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.refreshTokenExpiredAt = refreshTokenExpiredAt
        self.userId = userId
    }
    
    private func loadTokenStringsFromKeychain() async throws -> (String, String, String, Int) {
        guard
            let accessToken = try await TDKeyChainManager.shared.loadString(account: KeyChainConstant.accessToken.rawValue),
            let refreshToken = try await TDKeyChainManager.shared.loadString(account: KeyChainConstant.refreshToken.rawValue),
            let refreshTokenExpiredAtString = try await TDKeyChainManager.shared.loadString(account: KeyChainConstant.refreshTokenExpiredAt.rawValue),
            let userIdData = try await TDKeyChainManager.shared.loadString(account: KeyChainConstant.userId.rawValue),
            let userId = Int(userIdData)
        else { throw TDDataError.notFoundToken }
        
        return (accessToken, refreshToken, refreshTokenExpiredAtString, userId)
    }
    
    private func validateRefreshToken(expiredAtString: String) async throws -> Date {
        guard let expiredAt = convertToDate(expiredAtString), Date() < expiredAt else {
            try await removeToken()
            throw TDDataError.expiredRefreshToken
        }
        
        return expiredAt
    }
    
    /// 1. AccessToken이 만료되어 RefreshToken을 사용해 Token정보를 갱신할 때 사용
    /// 2. 로그인 성공할 때 사용
    public func saveToken(
        _ token: (
            accessToken: String,
            refreshToken: String,
            refreshTokenExpiredAt: String,
            userId: Int
        )
    ) async throws {
        try await TDKeyChainManager.shared.save(string: token.accessToken, account: KeyChainConstant.accessToken.rawValue, accessibility: kSecAttrAccessibleAfterFirstUnlock)
        try await TDKeyChainManager.shared.save(string: token.refreshToken, account: KeyChainConstant.refreshToken.rawValue, accessibility: kSecAttrAccessibleAfterFirstUnlock)
        try await TDKeyChainManager.shared.save(string: token.refreshTokenExpiredAt, account: KeyChainConstant.refreshTokenExpiredAt.rawValue, accessibility: kSecAttrAccessibleAfterFirstUnlock)
        let saveUserIdData = try JSONEncoder().encode(token.userId)
        try await TDKeyChainManager.shared.save(with: saveUserIdData, account: KeyChainConstant.userId.rawValue, accessibility: kSecAttrAccessibleAfterFirstUnlock)
        
        accessToken = token.accessToken
        refreshToken = token.refreshToken
        refreshTokenExpiredAt = convertToDate(token.refreshTokenExpiredAt)
        userId = token.userId
    }
    
    public func removeToken() async throws {
        accessToken = nil
        refreshToken = nil
        refreshTokenExpiredAt = nil
        userId = nil
        
        try await TDKeyChainManager.shared.delete(account: KeyChainConstant.accessToken.rawValue)
        try await TDKeyChainManager.shared.delete(account: KeyChainConstant.refreshToken.rawValue)
        try await TDKeyChainManager.shared.delete(account: KeyChainConstant.refreshTokenExpiredAt.rawValue)
        try await TDKeyChainManager.shared.delete(account: KeyChainConstant.userId.rawValue)
    }
    
    private func convertToDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter.date(from: string)
    }
    
#if DEBUG
    func setTokensForTesting(accessToken: String?, refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
#endif
    
    // MARK: - First Launch / Login Flags
    
    public func launchFirstLaunch() {
        UserDefaults.standard.set(true, forKey: UserDefaultsConstant.isFirstLaunch)
    }
    
    public func launchFirstLogin() {
        UserDefaults.standard.set(true, forKey: UserDefaultsConstant.isFirstLogin)
    }
    
    public func setUserName(name: String) {
        UserDefaults.standard.set(name, forKey: UserDefaultsConstant.username)
    }
    
    public func registerFCMToken(_ token: String) {
        pendingFCMToken = token
    }
}
