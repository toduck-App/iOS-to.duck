import Foundation
import Security

public actor TDKeyChainManager: KeyChainManaging {
    public static var shared: KeyChainManaging = TDKeyChainManager()
    
    private init() { }
    
    // MARK: - Save/Update
    /// 키체인에 데이터를 저장합니다.
    /// - Parameters:
    ///  - data: 저장할 데이터
    ///  - account: 저장할 데이터의 키
    ///  - accessibility: 데이터 접근성 (기본값: kSecAttrAccessibleWhenUnlocked)
    public func save(
        with data: Data,
        account: String,
        accessibility: CFString = kSecAttrAccessibleAfterFirstUnlock
    ) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecValueData: data,
            kSecAttrAccessible: accessibility
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecDuplicateItem:
            try update(data, account: account)
        case errSecSuccess:
            return
        default:
            throw KeyChainError.unexpectedStatus(status)
        }
    }
    
    /// 키체인에 데이터를 업데이트합니다.
    /// - Parameters:
    /// - data: 업데이트할 데이터
    /// - account: 업데이트할 데이터의 키
    private func update(
        _ data: Data,
        account: String
    ) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ]
        
        let attributes: [CFString: Any] = [kSecValueData: data]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else { throw KeyChainError.unexpectedStatus(status) }
    }
    
    // MARK: - Type-Safe Save Methods
    /// 키체인에 문자열을 저장해야 할 경우 데이터로 변환하여 저장합니다.
    public func save(
        string: String,
        account: String,
        accessibility: CFString = kSecAttrAccessibleAfterFirstUnlock
    ) throws {
        guard let data = string.data(using: .utf8) else { throw KeyChainError.typeConversionError }
        try save(with: data, account: account, accessibility: accessibility)
    }
    
    /// 키체인에 불리언 값을 저장해야 할 경우 데이터로 변환하여 저장합니다.
    public func save(
        bool: Bool,
        account: String,
        accessibility: CFString = kSecAttrAccessibleAfterFirstUnlock
    ) throws {
        let data = Data([bool ? 1 : 0])
        try save(with: data, account: account, accessibility: accessibility)
    }
    
    /// 키체인에 Codable 타입의 객체를 저장합니다.
    public func save<T: Codable>(
        object: T,
        account: String,
        accessibility: CFString = kSecAttrAccessibleAfterFirstUnlock
    ) throws {
        let data = try JSONEncoder().encode(object)
        try save(with: data, account: account, accessibility: accessibility)
    }
    
    // MARK: - Retrieve Methods
    /// 키체인에서 데이터를 불러옵니다.
    /// - Parameters:
    /// - account: 불러올 데이터의 키
    public func loadData(account: String) throws -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess: return result as? Data
        case errSecItemNotFound: return nil
        default: throw KeyChainError.unexpectedStatus(status)
        }
    }
    
    /// 키체인에서 문자열을 불러옵니다.
    public func loadString(account: String) throws -> String? {
        guard let data = try loadData(account: account) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeyChainError.typeConversionError
        }
        return string
    }
    
    /// 키체인에서 불리언 값을 불러옵니다.
    public func loadBool(account: String) throws -> Bool? {
        guard let data = try loadData(account: account), !data.isEmpty else { return nil }
        return data[0] != 0
    }
    
    /// 키체인에서 Codable 타입의 객체를 불러옵니다.
    public func loadObject<T: Codable>(account: String, type: T.Type) throws -> T? {
        guard let data = try loadData(account: account) else { return nil }
        return try JSONDecoder().decode(type, from: data)
    }
    
    // MARK: - Delete
    /// 키체인에서 데이터를 삭제합니다.
    /// - Parameters:
    /// - account: 삭제할 데이터의 키
    public func delete(account: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unexpectedStatus(status)
        }
    }
}
