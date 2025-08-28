import Foundation
@testable import TDCore

actor MockKeyChainManager: KeyChainManaging {
    private var storage: [String: Any] = [:]
    
    func loadData(account: String) throws -> Data? {
        return storage[account] as? Data
    }
    
    func loadString(account: String) throws -> String? {
        return storage[account] as? String
    }
    
    func save(with data: Data, account: String, accessibility: CFString) throws {
        storage[account] = data
    }
    
    func save(string: String, account: String, accessibility: CFString) throws {
        storage[account] = string
    }
    
    func save(bool: Bool, account: String, accessibility: CFString) throws {
        storage[account] = bool
    }
    
    func save<T>(object: T, account: String, accessibility: CFString) throws where T : Decodable, T : Encodable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        storage[account] = data
    }
    
    func loadBool(account: String) throws -> Bool? {
        return storage[account] as? Bool
    }
    
    func loadObject<T>(account: String, type: T.Type) throws -> T? where T : Decodable, T : Encodable {
        guard let data = storage[account] as? Data else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func delete(account: String) throws {
        storage[account] = nil
    }
}
