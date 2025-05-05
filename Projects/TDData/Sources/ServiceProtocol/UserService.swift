
public protocol UserService {
    func requestUserBlock(userId: Int) async throws
    func requestUserUnBlock(userId: Int) async throws
    func requestUserBlockList() async throws -> TDBlockedUserListDTO
    func requestUserProfile(userId: Int) async throws -> TDUserProfileResponseDTO
    func requestFollow(userId: Int) async throws
    func requestUnfollow(userId: Int) async throws
    func requestUserPosts(userId: Int, cursor: Int?, limit: Int) async throws -> TDPostListDTO
    func requestUserRoutines(userId: Int) async throws -> RoutineListResponseDTO
    func requestShareRoutine(routineID: Int, routine: RoutineRequestDTO) async throws
    func requestMyCommentList(cursor: Int?, limit: Int) async throws -> TDCommentListDTO
}
