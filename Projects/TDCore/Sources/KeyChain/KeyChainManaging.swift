import Foundation

public protocol KeyChainManaging: Actor {
    func save(with data: Data, account: String, accessibility: CFString) async throws
    func save(string: String, account: String, accessibility: CFString) async throws
    func save(bool: Bool, account: String, accessibility: CFString) async throws
    func save<T: Codable>(object: T, account: String, accessibility: CFString) async throws
    
    func loadData(account: String) async throws -> Data?
    func loadString(account: String) async throws -> String?
    func loadBool(account: String) async throws -> Bool?
    func loadObject<T: Codable>(account: String, type: T.Type) async throws -> T?
    
    func delete(account: String) async throws
}
