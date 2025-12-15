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
        
        container.register(LoginUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return LoginUseCaseImpl(repository: repository)
        }
        
        container.register(RequestPhoneVerificationCodeUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return RequestPhoneVerificationCodeUseCaseImpl(repository: repository)
        }
        
        container.register(VerifyPhoneCodeUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return VerifyPhoneCodeUseCaseImpl(repository: repository)
        }
        
        container.register(CheckDuplicateUserIdUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return CheckDuplicateUserIdUseCaseImpl(repository: repository)
        }
        
        container.register(RegisterUserUseCase.self) { resolver in
            guard let repository = resolver.resolve(AuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return RegisterUserUseCaseImpl(repository: repository)
        }
        
        // MARK: - User Auth UseCases
        
        container.register(FindUserIdUseCase.self) { resolve in
            guard let repository = resolve.resolve(UserAuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return FindUserIdUseCaseImpl(repository: repository)
        }
        
        container.register(RequestVerificationCodeForFindUserUseCase.self) { resolve in
            guard let repository = resolve.resolve(UserAuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return RequestVerificationCodeForFindUserUseCaseImpl(repository: repository)
        }
        
        container.register(RequestValidFindUserUseCase.self) { resolve in
            guard let repository = resolve.resolve(UserAuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return RequestValidFindUserUseCaseImpl(repository: repository)
        }
        
        container.register(ChangePasswordUseCase.self) { resolve in
            guard let repository = resolve.resolve(UserAuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return ChangePasswordUseCaseImpl(repository: repository)
        }
        
        container.register(UserLogoutUseCase.self) { resolve in
            guard let repository = resolve.resolve(UserAuthRepository.self) else {
                fatalError("컨테이너에 AuthRepository가 등록되어 있지 않습니다.")
            }
            return UserLogoutUseCaseImpl(repository: repository)
        }
        
        // MARK: - MyPage UseCases
        
        container.register(FetchUserNicknameUseCase.self) { resolver in
            guard let repository = resolver.resolve(MyPageRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchUserNicknameUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateUserNicknameUseCase.self) { resolver in
            guard let repository = resolver.resolve(MyPageRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return UpdateUserNicknameUseCaseImpl(repository: repository)
        }
        
        container.register(BlockUserUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return BlockUserUseCaseImpl(repository: repository)
        }
        
        container.register(UnBlockUserUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return UnBlockUserUseCaseImpl(repository: repository)
        }
        
        // MARK: - Create UseCases
        
        container.register(CreateCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 SocialRepository가 등록되어 있지 않습니다.")
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
            guard let repository = resolver.resolve(SocialRepository.self) else {
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
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 SocialRepository가 등록되어 있지 않습니다.")
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
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return DeletePostUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteRoutineAfterCurrentDayUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return DeleteRoutineAfterCurrentDayUseCaseImpl(repository: repository)
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
        
        // MARK: - Notification UseCases
        container.register(RegisterDeviceTokenUseCase.self) { resolver in
            guard let repository = resolver.resolve(NotificationRepository.self) else {
                fatalError("컨테이너에 NotificationRepository가 등록되어 있지 않습니다.")
            }
            return RegisterDeviceTokenUseCaseImpl(repository: repository)
        }
        
        container.register(FetchNotificationListUseCase.self) { resolver in
            guard let notificationRepository = resolver.resolve(NotificationRepository.self) else {
                fatalError("컨테이너에 NotificationRepository가 등록되어 있지 않습니다.")
            }
            
            guard let userRepository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            
            let fetchUserUseCase = FetchUserUseCaseImpl(repository: userRepository)
            return FetchNotificationListUseCaseImpl(
                repository: notificationRepository,
                fetchUserUseCase: fetchUserUseCase
            )
        }
        
        container.register(ReadAllNotificationsUseCase.self) { resolver in
            guard let repository = resolver.resolve(NotificationRepository.self) else {
                fatalError("컨테이너에 NotificationRepository가 등록되어 있지 않습니다.")
            }
            return ReadAllNotificationsUseCaseImpl(repository: repository)
        }
        
        container.register(ReadNotificationUseCase.self) { resolver in
            guard let repository = resolver.resolve(NotificationRepository.self) else {
                fatalError("컨테이너에 NotificationRepository가 등록되어 있지 않습니다.")
            }
            return ReadNotificationUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteDeviceTokenUseCase.self) { resolver in
            guard let repository = resolver.resolve(NotificationRepository.self) else {
                fatalError("컨테이너에 NotificationRepository가 등록되어 있지 않습니다.")
            }
            return DeleteDeviceTokenUseCaseImpl(repository: repository)
        }
        
        // MARK: - Fetch UseCases
        
        container.register(FetchAvailableRoutineListUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return FetchAvailableRoutineListUseCaseImpl(repository: repository)
        }
        
        container.register(FetchCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 SocialRepository가 등록되어 있지 않습니다.")
            }
            return FetchCommentUseCaseImpl(repository: repository)
        }
        
        container.register(FetchCategoriesUseCase.self) { resolver in
            guard let repository = resolver.resolve(CategoryRepository.self) else {
                fatalError("컨테이너에 CategoryRepository가 등록되어 있지 않습니다.")
            }
            return FetchCategoriesUseCaseImpl(repository: repository)
        }
        
        container.register(FetchDiaryListUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return FetchDiaryListUseCaseImpl(repository: repository)
        }
        
        container.register(FetchPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return FetchPostUseCaseImpl(repository: repository)
        }
        
        container.register(FetchFocusListUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return FetchFocusListUseCaseImpl(repository: repository)
        }
        
        container.register(FetchFocusPercentUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return FetchFocusPercentUseCaseImpl(repository: repository)
        }
        
        container.register(FetchScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return FetchScheduleUseCaseImpl(repository: repository)
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
        
        container.register(FetchRoutineListUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return FetchRoutineListUseCaseImpl(repository: repository)
        }
        
        container.register(FetchWeeklyTodoListUseCase.self) { resolver in
            guard let fetchScheduleListUseCase = resolver.resolve(FetchScheduleListUseCase.self) else {
                fatalError("컨테이너에 FetchScheduleListUseCase가 등록되어 있지 않습니다.")
            }
            guard let fetchRoutineListForDatesUseCase = resolver.resolve(FetchRoutineListForDatesUseCase.self) else {
                fatalError("컨테이너에 FetchRoutineListUseCase가 등록되어 있지 않습니다.")
            }
            return FetchWeeklyTodoListUseCaseImpl(
                fetchScheduleListUseCase: fetchScheduleListUseCase,
                fetchRoutineListForDatesUseCase: fetchRoutineListForDatesUseCase
            )
        }
        
        container.register(ProcessDailyTodoListUseCase.self) { _ in
            return ProcessDailyTodoListUseCaseImpl()
        }

        container.register(RemoveTodoItemFromLocalDataUseCase.self) { _ in
            return RemoveTodoItemFromLocalDataUseCaseImpl()
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
        
        container.register(FetchRoutineListForDatesUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return FetchRoutineListForDatesUseCaseImpl(repository: repository)
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
        
        container.register(FetchDiaryCompareCountUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return FetchDiaryCompareCountUseCaseImpl(repository: repository)
        }
        
        container.register(FinishScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return FinishScheduleUseCaseImpl(repository: repository)
        }
        
        container.register(FinishRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return FinishRoutineUseCaseImpl(repository: repository)
        }
        
        container.register(MoveTomorrowScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return MoveTomorrowScheduleUseCaseImpl(repository: repository)
        }
        
        container.register(ReportCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 SocialRepository가 등록되어 있지 않습니다.")
            }
            return ReportCommentUseCaseImpl(repository: repository)
        }
        
        container.register(ReportPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return ReportPostUseCaseImpl(repository: repository)
        }
        
        container.register(SearchPostUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return SearchPostUseCaseImpl(repository: repository)
        }
        
        container.register(ToggleCommentLikeUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 SocialRepository가 등록되어 있지 않습니다.")
            }
            return ToggleCommentLikeUseCaseImpl(repository: repository)
        }
        
        container.register(TogglePostLikeUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
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
        
        container.register(UpdateDiaryUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return UpdateDiaryUseCaseImpl(repository: repository)
        }
        
        container.register(UpdatePostUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 PostRepository가 등록되어 있지 않습니다.")
            }
            return UpdatePostUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateScheduleUseCase.self) { resolver in
            guard let repository = resolver.resolve(ScheduleRepository.self) else {
                fatalError("컨테이너에 ScheduleRepository가 등록되어 있지 않습니다.")
            }
            return UpdateScheduleUseCaseImpl(repository: repository)
        }
        container.register(FetchTimerSettingUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return FetchTimerSettingUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateTimerSettingUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return UpdateTimerSettingUseCaseImpl(repository: repository)
        }
        
        container.register(FocusTimerUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return FocusTimerUseCaseImpl(repository: repository)
        }
        
        container.register(RestTimerUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return RestTimerUseCaseImpl(repository: repository)
        }
        
        container.register(PauseTimerUseCase.self) { _ in
            PauseTimerUseCaseImpl()
        }
        
        container.register(FetchFocusCountUseCase.self, factory: { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return FetchFocusCountImpl(repository: repository)
        })
        
        container.register(UpdateFocusCountUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return UpdateFocusCountUseCaseImpl(repository: repository)
        }
        
        container.register(ResetFocusCountUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
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
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return FetchTimerThemeUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateTimerThemeUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return UpdateTimerThemeUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return UpdateRoutineUseCaseImpl(repository: repository)
        }
        
        container.register(ShouldMarkAllDayUseCase.self) { _ in
            ShouldMarkAllDayUseCaseImpl()
        }
        
        container.register(DeleteCommentUseCase.self) { resolver in
            guard let repository = resolver.resolve(SocialRepository.self) else {
                fatalError("컨테이너에 SocialRepository가 등록되어 있지 않습니다.")
            }
            return DeleteCommentUseCaseImpl(repository: repository)
        }
        
        container.register(SaveFocusUseCase.self) { resolver in
            guard let repository = resolver.resolve(FocusRepository.self) else {
                fatalError("컨테이너에 FocusRepository가 등록되어 있지 않습니다.")
            }
            return SaveFocusUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteRoutineForCurrentDayUseCase.self) { resolver in
            guard let repository = resolver.resolve(RoutineRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return DeleteRoutineForCurrentDayUseCaseImpl(repository: repository)
        }
        
        container.register(ShareRoutineUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 RoutineRepository가 등록되어 있지 않습니다.")
            }
            return ShareRoutineUseCaseImpl(repository: repository)
        }
        
        container.register(FetchBlockedUsersUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("컨테이너에 UserRepository가 등록되어 있지 않습니다.")
            }
            return FetchBlockedUsersUseCaseImpl(repository: repository)
        }
        
        container.register(UpdateProfileImageUseCase.self) { resolver in
            guard let repository = resolver.resolve(MyPageRepository.self) else {
                fatalError("컨테이너에 MyPageRepository가 등록되어 있지 않습니다.")
            }
            return UpdateProfileImageUseCaseImpl(repository: repository)
        }
        
        container.register(WithdrawUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserAuthRepository.self) else {
                fatalError("컨테이너에 UserAuthRepository가 등록되어 있지 않습니다.")
            }
            return WithdrawUseCaseImpl(repository: repository)
        }
        
        container.register(FetchStreakUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return FetchStreakUseCaseImpl(repository: repository)
        }
        
        container.register(ValidateVersionUseCase.self) { resolver in
            guard let repository = resolver.resolve(BackofficeRepository.self) else {
                fatalError("컨테이너에 BackofficeRepository가 등록되어 있지 않습니다.")
            }
            return ValidateVersionUseCaseImpl(repository: repository)
        }
        
        container.register(FetchEventsUseCase.self) { resolver in
            guard let repository = resolver.resolve(EventRepository.self) else {
                fatalError("컨테이너에 EventRepository가 등록되어 있지 않습니다.")
            }
            return FetchEventsUseCaseImpl(repository: repository)
        }
        
        container.register(FetchEventDetailsUseCase.self) { resolver in
            guard let repository = resolver.resolve(EventRepository.self) else {
                fatalError("컨테이너에 EventRepository가 등록되어 있지 않습니다.")
            }
            return FetchEventDetailsUseCaseImpl(repository: repository)
        }
        
        container.register(FetchParticipateEventUseCase.self) { resolver in
            guard let repository = resolver.resolve(EventRepository.self) else {
                fatalError("컨테이너에 EventRepository가 등록되어 있지 않습니다.")
            }
            return FetchParticipateEventUseCaseImpl(repository: repository)
        }
        
        container.register(ParticipateEventUseCase.self) { resolver in
            guard let repository = resolver.resolve(EventRepository.self) else {
                fatalError("컨테이너에 EventRepository가 등록되어 있지 않습니다.")
            }
            return ParticipateEventUseCaseImpl(repository: repository)
        }
        
        container.register(FetchDiaryKeywordUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return FetchDiaryKeywordUseCaseImpl(repository: repository)
        }
        
        container.register(CreateDiaryKeywordUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return CreateDiaryKeywordUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteDiaryKeywordUseCase.self) { resolver in
            guard let repository = resolver.resolve(DiaryRepository.self) else {
                fatalError("컨테이너에 DiaryRepository가 등록되어 있지 않습니다.")
            }
            return DeleteDiaryKeywordUseCaseImpl(repository: repository)
        }
    }
}
