import Swinject

public struct DomainAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        // MARK: - Auth UseCases
        container.register(AppleLoginUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return AppleLoginUseCaseImpl(repository: repository)
        }
        
        container.register(KakaoLoginUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return KakaoLoginUseCaseImpl(repository: repository)
        }
        
        // MARK: - Block UseCases
        container.register(BlockCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return BlockCommentUseCaseImpl(repository: repository)
        }
        
        container.register(BlockPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return BlockPostUseCaseImpl(repository: repository)
        }
        
        container.register(BlockUserUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return BlockUserUseCaseImpl(repository: repository)
        }
        
        // MARK: - Create UseCases
        container.register(CreateCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return CreateCommentUseCaseImpl(repository: repository)
        }
        
        container.register(CreateDiaryUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return CreateDiaryUseCaseImpl(repository: repository)
        }
        
        container.register(CreatePostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return CreatePostUseCaseImpl(repository: repository)
        }
        
        container.register(CreateRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return CreateRoutineUseCaseImpl(repository: repository)
        }
        
        container.register(CreateScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return CreateScheduleUseCaseImpl(repository: repository)
        }
        
        // MARK: - Delete UseCases
        container.register(DeleteCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return DeleteCommentUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteDiaryUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return DeleteDiaryUseCaseImpl(repository: repository)
        }
        
        container.register(DeletePostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return DeletePostUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return DeleteRoutineUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return DeleteScheduleUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteKeywordUseCase.self) { resolver in
            guard let repository = resolver.resolve(RecentKeywordRepository.self) else {
                fatalError("컨테이너에 RecentKeywordRepository가 등록되어 있지 않습니다.")
            }
            return DeleteKeywordUseCaseImpl(repository: repository)
        }
        
        // MARK: - Fetch UseCases
        container.register(FetchCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return FetchCommentUseCaseImpl(repository: repository)
        }
        
        container.register(FetchCategoriesUseCase.self) { resolver in
            guard let repository = resolver.resolve(CategoryRepository.self) else {
                fatalError("컨테이너에 CategoryRepository가 등록되어 있지 않습니다.")
            }
            return FetchCategoriesUseCaseImpl(repository: repository)
        }
        
        container.register(FetchDiaryUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return FetchDiaryUseCaseImpl(repository: repository)
        }
        
        container.register(FetchPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return FetchPostUseCaseImpl(repository: repository)
        }
        
        container.register(FetchRoutineListUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return FetchRoutineListUseCaseImpl(repository: repository)
        }
        
        container.register(FetchRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return FetchRoutineUseCaseImpl(repository: repository)
        }
        
        container.register(FetchScheduleListUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return FetchScheduleListUseCaseImpl(repository: repository)
        }
        
        container.register(FetchScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return FetchScheduleUseCaseImpl(repository: repository)
        }
        
        container.register(FetchUserDetailUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchUserDetailUseCaseImpl(repository: repository)
        }
        
        container.register(FetchUserPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchUserPostUseCaseImpl(repository: repository)
        }
        
        container.register(FetchUserRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchUserRoutineUseCaseImpl(repository: repository)
        }

        container.register(FetchUserShareUrlUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchUserShareUrlUseCaseImpl(repository: repository)
        }

        container.register(FetchUserUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchUserUseCaseImpl(repository: repository)
        }
        
        container.register(FetchKeywordUseCase.self) { resolver in
            guard let repository = resolver.resolve(RecentKeywordRepository.self) else {
                fatalError("컨테이너에 RecentKeywordRepository가 등록되어 있지 않습니다.")
            }
            return FetchKeywordUseCaseImpl(repository: repository)
        }
        
        container.register(MoveTomorrowScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return MoveTomorrowScheduleUseCaseImpl(repository: repository)
        }
        
        container.register(ReportCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return ReportCommentUseCaseImpl(repository: repository)
        }
        
        container.register(ReportPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return ReportPostUseCaseImpl(repository: repository)
        }

        container.register(SearchPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return SearchPostUseCaseImpl(repository: repository)
        }

        container.register(ToggleCommentLikeUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return ToggleCommentLikeUseCaseImpl(repository: repository)
        }

        container.register(TogglePostLikeUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return TogglePostLikeUseCaseImpl(repository: repository)
        }

        container.register(ToggleUserFollowUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return ToggleUserFollowUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateCategoriesUseCase.self) { resolver in
            guard let repository = resolver.resolve(CategoryRepository.self) else {
                fatalError("컨테이너에 CategoryRepository가 등록되어 있지 않습니다.")
            }
            return UpdateCategoriesUseCaseImpl(repository: repository)
        }

        container.register(UpdateCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(CommentRepository.self) else {
                fatalError("컨테이너에 CommentRepository가 등록되어 있지 않습니다.")
            }
            return UpdateCommentUseCaseImpl(repository: repository)
        }

        container.register(UpdateDiaryUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return UpdateDiaryUseCaseImpl(repository: repository)
        }

        container.register(UpdatePostUseCase.self) { resolver in
            guard let repository = resolver.resolve(PostRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return UpdatePostUseCaseImpl(repository: repository)
        }

        container.register(UpdateRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return UpdateRoutineUseCaseImpl(repository: repository)
        }

        container.register(UpdateScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return UpdateScheduleUseCaseImpl(repository: repository)
        }
        container.register(FetchTimerSettingUseCase.self) { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return FetchTimerSettingUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateTimerSettingUseCase.self) { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return UpdateTimerSettingUseCaseImpl(repository: repository)
        }
        
        container.register(TimerUseCase.self) { resolver in
            return TimerUseCaseImpl()
        }
        
        container.register(FetchFocusCountUseCase.self, factory: { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return FetchFocusCountImpl(repository: repository)
        })
        
        container.register(UpdateFocusCountUseCase.self) { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return UpdateFocusCountUseCaseImpl(repository: repository)
        }

        container.register(ResetFocusCountUseCase.self) { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return ResetFocusCountUseCaseImpl(repository: repository)   
        }
        
        container.register(UpdateKeywordUseCase.self) { resolver in
            guard let repository = resolver.resolve(RecentKeywordRepository.self) else {
                fatalError("컨테이너에 RecentKeywordRepository가 등록되어 있지 않습니다.")
            }
            return UpdateKeywordUseCaseImpl(repository: repository)
        }

        container.register(FetchTimerThemeUseCase.self) { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return FetchTimerThemeUseCaseImpl(repository: repository)
        }

        container.register(UpdateTimerThemeUseCase.self) { resolver in
            guard let repository = resolver.resolve(TimerRepository.self) else {
                fatalError("컨테이너에 TimerRepository가 등록되어 있지 않습니다.")
            }
            return UpdateTimerThemeUseCaseImpl(repository: repository)
        }
    }
}
