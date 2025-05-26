import TDData
import TDDomain
import Swinject

public struct ServiceAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(AuthService.self) { _ in
            return AuthServiceImpl()
        }
        
        container.register(DiaryService.self) { _ in
            return DiaryServiceImpl()
        }
        
        container.register(FocusService.self) { _ in
            return FocusServiceImpl()
        }
        
        container.register(ScheduleService.self) { _ in
            return ScheduleServiceImpl()
        }
        
        container.register(UserAuthService.self) { _ in
            return UserAuthServiceImpl()
        }
        
        container.register(MyPageService.self) { _ in
            return MyPageServiceImpl()
        }
        
        container.register(SocialService.self) { _ in
            return SocialServiceImpl()
        }
        
        container.register(AwsService.self) { _ in
            return AwsServiceImpl()
        }
        
        container.register(UserService.self) { _ in
            return UserServiceImpl()
        }
        
        container.register(RoutineService.self) { _ in
            return RoutineServiceImpl()
        }
        
        container.register(NotificationService.self) { _ in
            return NotificationServiceImpl()
        }
    }
}
