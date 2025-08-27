import Foundation
@testable import TDCore

actor MockKeyChainManager: KeyChainManaging {
    func loadData(account: String) async throws -> Data? {
        return storage[account] as? Data
    }
    
    func loadString(account: String) async throws -> String? {
        return storage[account] as? String
    }
    
    func save(with data: Data, account: String, accessibility: CFString) async throws {
        storage[account] = data
    }
    
    func save(string: String, account: String, accessibility: CFString) async throws {
        storage[account] = string
    }
    
    func save(bool: Bool, account: String, accessibility: CFString) async throws {
        storage[account] = bool
    }
    
    func save<T>(object: T, account: String, accessibility: CFString) async throws where T : Decodable, T : Encodable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        storage[account] = data	
    }
    
    func loadBool(account: String) async throws -> Bool? {
        return storage[account] as? Bool
    }
    
    func loadObject<T>(account: String, type: T.Type) async throws -> T? where T : Decodable, T : Encodable {
        guard let data = storage[account] as? Data else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    // 실제 키체인 대신 사용할 메모리상의 딕셔너리
    var storage: [String: Any] = [:]
    func delete(account: String) async throws {
        storage[account] = nil
    }
}

// 실제 KeyChainManagerWithActor와 MockKeyChainManager가 상호 교체 가능하도록
// 프로토콜을 정의하고, 양쪽 모두 이 프로토콜을 따르도록 하는 것이 가장 이상적인 방법입니다.
// 지금은 간단하게 Mock 객체를 생성해서 사용하겠습니다.
