import TDDomain
import Swinject

public struct DataAssembly: Assembly {
    public init() { }
    
    public func assemble(container: Container) {
        container.register(AuthRepository.self) { _ in
            guard let service = container.resolve(AuthService.self) else {
                fatalError("AuthService is not registered")
            }
            return AuthRepositoryImpl(service: service)
        }.inObjectScope(.container)
        
        container.register(CommentRepository.self) { _ in
            return CommentRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(CategoryRepository.self) { _ in
            guard let storage = container.resolve(CategoryStorage.self) else {
                fatalError("Storage is not registered")
            }
            return CategoryRepositoryImpl(storage: storage)
        }.inObjectScope(.container)
        
        container.register(DiaryRepository.self) { _ in
            return DiaryRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(MyPageRepository.self) { _ in
            guard let service = container.resolve(MyPageService.self) else {
                fatalError("MyPageService is not registered")
            }
            return MyPageRepositoryImpl(service: service)
        }.inObjectScope(.container)
        
        container.register(PostRepository.self) { _ in
            return PostRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(RoutineRepository.self) { _ in
            return RoutineRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(ScheduleRepository.self) { _ in
            guard let service = container.resolve(ScheduleService.self) else {
                fatalError("ScheduleService is not registered")
            }
            return ScheduleRepositoryImpl(service: service)
        }.inObjectScope(.container)
            
        container.register(UserRepository.self) { _ in
            return UserRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(UserAuthRepository.self) { _ in
            guard let service = container.resolve(UserAuthService.self) else {
                fatalError("UserAuthService is not registered")
            }
            return UserAuthRepositoryImpl(service: service)
        }
        
        container.register(RecentKeywordRepository.self) { _ in
            guard let storage = container.resolve(RecentKeywordStorage.self) else {
                fatalError("Storage is not registered")
            }
            return RecentKeywordRepositoryImpl(storage: storage)
        }

        container.register(TimerRepository.self) { _ in
            guard let storage = container.resolve(TimerStorage.self) else {
                fatalError("Storage is not registered")
            }
            return TimerRepositoryImpl(storage: storage)
        }.inObjectScope(.container)
    }
}
