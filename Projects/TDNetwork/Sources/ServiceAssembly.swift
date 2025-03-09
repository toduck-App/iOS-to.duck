import TDData
import TDDomain
import Swinject

public struct ServiceAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(AuthService.self) { _ in
            return AuthServiceImpl()
        }
    }
}
