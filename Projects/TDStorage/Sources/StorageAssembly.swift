import TDData
import TDDomain
import Swinject

public struct StorageAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(CategoryStorage.self) { _ in
            CategoryStorageImpl()
        }
    }
}
