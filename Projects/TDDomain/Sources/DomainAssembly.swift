//
//  DomainAssembly.swift
//  TDDomain
//
//  Created by 박효준 on 10/21/24.
//

import Swinject

public struct DomainAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(FetchPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            
            return FetchPostUseCaseImpl(repository: repository)
        }
        
        container.register(TogglePostLikeUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return TogglePostLikeUseCaseImpl(repository: repository)
        }
        
        container.register(CreateCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return CreateCommentUseCaseImpl(repository: repository)
        }
        
        container.register(FetchCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return FetchCommentUseCaseImpl(repository: repository)
        }
        
        container.register(ReportPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return ReportPostUseCaseImpl(repository: repository)
        }
        
        container.register(FetchScheduleListUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return FetchScheduleListUseCaseImpl(repository: repository)
        }
        
        container.register(BlockUserUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return BlockUserUseCaseImpl(repository: repository)
        }
    }
}
