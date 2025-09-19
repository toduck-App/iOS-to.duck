import Foundation

public protocol KeyChainManaging: Actor {
    func save(with data: Data, account: String, accessibility: CFString) throws
    func save(string: String, account: String, accessibility: CFString) throws
    func save(bool: Bool, account: String, accessibility: CFString) throws
    func save<T: Codable>(object: T, account: String, accessibility: CFString) throws
    
    func loadData(account: String) throws -> Data?
    func loadString(account: String) throws -> String?
    func loadBool(account: String) throws -> Bool?
    func loadObject<T: Codable>(account: String, type: T.Type) throws -> T?
    
    func delete(account: String) throws
}
