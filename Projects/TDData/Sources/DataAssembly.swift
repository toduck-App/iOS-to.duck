//
//  DataAssembly.swift
//  TDData
//
//  Created by 박효준 on 10/21/24.
//

import TDDomain
import Swinject

public struct DataAssembly: Assembly {
    public init() { }
    
    public func assemble(container: Container) {
        container.register(PostRepository.self) { _ in
            return PostRepositoryImpl()
        }
        
        container.register(CommentRepository.self) { _ in
            return CommentRepositoryImpl()
        }
        
        container.register(ScheduleRepository.self) { _ in
            return ScheduleRepositoryImpl()
        }
            
        container.register(UserRepository.self) { _ in
            return UserRepositoryImpl()
        }
        
        container.register(RoutineRepository.self) { _ in
            return RoutineRepositoryImpl()
        }
    }
        
}
