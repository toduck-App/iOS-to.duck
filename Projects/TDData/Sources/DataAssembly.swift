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
        
        container.register(PostRepository.self) { _ in
            return PostRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(RoutineRepository.self) { _ in
            return RoutineRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(ScheduleRepository.self) { _ in
            return ScheduleRepositoryImpl()
        }.inObjectScope(.container)
            
        container.register(UserRepository.self) { _ in
            return UserRepositoryImpl()
        }.inObjectScope(.container)
        
        container.register(RecentKeywordRepository.self) { _ in
            guard let storage = container.resolve(RecentKeywordStorage.self) else {
                fatalError("Storage is not registered")
            }
            return RecentKeywordRepositoryImpl(storage: storage)
        }
    }
}
