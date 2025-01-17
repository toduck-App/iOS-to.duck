import XCTest
import TDDomain
@testable import TDCore

final class FetchCategoriesUseCaseTests: XCTestCase {
    private var mockRepository: MockCategoryRepository!
    private var fetchCategoriesUseCase: FetchCategoriesUseCaseImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockCategoryRepository()
        fetchCategoriesUseCase = FetchCategoriesUseCaseImpl(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        fetchCategoriesUseCase = nil
        try super.tearDownWithError()
    }

    func test_카테고리_가져오기_성공() async throws {
        // Arrange 준비 단계: Mock 데이터를 설정
        let expectedCategories = [
            TDCategory(colorHex: "#123456", imageName: "test1"),
            TDCategory(colorHex: "#654321", imageName: "test2")
        ]
        mockRepository.stubbedFetchCategoriesResult = expectedCategories

        // Act 실행 단계: UseCase의 execute 호출
        let categories = try await fetchCategoriesUseCase.execute()

        // Assert 검증 단계: 결과 확인
        XCTAssertEqual(categories.count, 2, "가져온 카테고리의 개수가 맞아야 함")
        XCTAssertEqual(categories[0].colorHex, "#123456", "첫 번째 카테고리 색상 확인")
        XCTAssertEqual(categories[0].imageName, "test1", "첫 번째 카테고리 이미지 확인")
        XCTAssertEqual(categories[1].colorHex, "#654321", "두 번째 카테고리 색상 확인")
        XCTAssertEqual(categories[1].imageName, "test2", "두 번째 카테고리 이미지 확인")
    }

    func test_카테고리_가져오기_실패() async throws {
        // Arrange 준비 단계: Mock에서 에러를 반환하도록 설정
        mockRepository.stubbedFetchCategoriesError = TDDataError.fetchEntityFaliure

        // Act & Assert 실행 및 검증 단계: UseCase의 execute 호출
        do {
            _ = try await fetchCategoriesUseCase.execute()
            XCTFail("execute() 호출은 실패해야 함")
        } catch let error as TDDataError {
            XCTAssertEqual(error, TDDataError.fetchEntityFaliure, "에러가 TDDataError.fetchEntityFaliure여야 함")
        } catch {
            XCTFail("예상치 못한 에러 발생: \(error)")
        }
    }
}
