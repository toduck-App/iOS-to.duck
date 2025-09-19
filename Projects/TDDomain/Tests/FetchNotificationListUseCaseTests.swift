import XCTest
@testable import TDCore
@testable import TDDomain

final class FetchNotificationListUseCaseTests: XCTestCase {
    
    // MARK: - Test Cases
    
    func test_FOLLOW타입일때_isFollowed_채워짐() async throws {
        // Arrange
        let notification = makeFollowNotification(senderId: 1)
        let mockRepo = MockNotificationRepository()
        mockRepo.stubbedNotificationList = TDNotificationList(notifications: [notification])
        
        let mockUserUseCase = MockFetchUserUseCase()
        mockUserUseCase.stubbedIsFollowing = [1: true]
        
        let sut = FetchNotificationListUseCaseImpl(
            repository: mockRepo,
            fetchUserUseCase: mockUserUseCase
        )
        
        // Act
        let result = try await sut.execute(page: 0, size: 10)
        
        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.isFollowed, true)
        XCTAssertEqual(mockUserUseCase.executedUserIDs, [1])
    }
    
    func test_FOLLOW아닐때_isFollowed_호출되지않음() async throws {
        // Arrange
        let notification = makeNonFollowNotification()
        let mockRepo = MockNotificationRepository()
        mockRepo.stubbedNotificationList = TDNotificationList(notifications: [notification])
        
        let mockUserUseCase = MockFetchUserUseCase()
        
        let sut = FetchNotificationListUseCaseImpl(
            repository: mockRepo,
            fetchUserUseCase: mockUserUseCase
        )
        
        // Act
        let result = try await sut.execute(page: 0, size: 10)
        
        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertNil(result.first?.isFollowed)
        XCTAssertTrue(mockUserUseCase.executedUserIDs.isEmpty)
    }
    
    func test_유저조회실패해도_계속진행됨() async throws {
        // Arrange
        let notification = makeFollowNotification(senderId: 1)
        let mockRepo = MockNotificationRepository()
        mockRepo.stubbedNotificationList = TDNotificationList(notifications: [notification])
        
        final class ThrowingUserUseCase: FetchUserUseCase {
            func execute(id: User.ID) async throws -> (User, UserDetail) {
                throw NSError(domain: "TestError", code: -1)
            }
        }
        
        let sut = FetchNotificationListUseCaseImpl(
            repository: mockRepo,
            fetchUserUseCase: ThrowingUserUseCase()
        )
        
        // Act
        let result = try await sut.execute(page: 0, size: 10)
        
        // Assert
        XCTAssertEqual(result.count, 1)
        XCTAssertNil(result.first?.isFollowed)
    }
    
    // MARK: - Test Helpers
    
    func makeFollowNotification(senderId: Int) -> TDNotificationDetail {
        TDNotificationDetail(
            id: senderId,
            senderId: senderId,
            senderImageUrl: nil,
            type: "FOLLOW",
            title: "팔로우 알림",
            body: "내용",
            actionUrl: nil,
            data: NotificationInfo.comment(commenterName: "", commentContent: "", postId: 0),
            isRead: false,
            createdAt: "2025-05-25"
        )
    }
    
    func makeNonFollowNotification() -> TDNotificationDetail {
        TDNotificationDetail(
            id: 999,
            senderId: 42,
            senderImageUrl: nil,
            type: "LIKE",
            title: "좋아요 알림",
            body: "내용",
            actionUrl: nil,
            data: NotificationInfo.comment(commenterName: "", commentContent: "", postId: 0),
            isRead: false,
            createdAt: "2025-05-25"
        )
    }
    
}
