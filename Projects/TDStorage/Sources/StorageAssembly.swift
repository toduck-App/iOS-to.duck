import TDData
import TDDomain
import Swinject

public struct StorageAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(CategoryStorage.self) { _ in
            CategoryStorageImpl()
        }
        
        container.register(RecentKeywordStorage.self) { _ in
            RecentKeywordStorageImpl()
        }

        container.register(TimerStorage.self) { _ in
            TimerStorageImpl()
        }
        container.register(DiaryKeywordStorage.self) { _ in
            DiaryKeywordStorageImpl()
        }
    }
}
