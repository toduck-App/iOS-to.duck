import XCTest
import TDDomain
import TDCore

final class UpdateCategoriesUseCaseTests: XCTestCase {
    private var mockRepository: MockCategoryRepository!
    private var updateCategoriesUseCase: UpdateCategoriesUseCaseImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockCategoryRepository()
        updateCategoriesUseCase = UpdateCategoriesUseCaseImpl(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        mockRepository = nil
        updateCategoriesUseCase = nil
        try super.tearDownWithError()
    }

    func test_카테고리_업데이트_성공() async throws {
        // Arrange 준비 단계: Mock에서 성공하도록 설정
        let categoriesToUpdate = [
            TDCategory(colorHex: "#ABCDEF", imageName: "update1"),
            TDCategory(colorHex: "#FEDCBA", imageName: "update2")
        ]
        mockRepository.stubbedUpdateCategoriesResult = .success(())

        // Act 실행 단계: UseCase의 execute 호출
        try await updateCategoriesUseCase.execute(categories: categoriesToUpdate)

        // Assert 검증 단계: 에러가 발생하지 않는지 확인
        XCTAssertTrue(mockRepository.invokedUpdateCategories, "updateCategories가 호출되어야 함")
        XCTAssertEqual(mockRepository.invokedUpdateCategoriesParameters, categoriesToUpdate, "전달된 카테고리가 일치해야 함")
    }

    func test_카테고리_업데이트_실패() async throws {
        // Arrange 준비 단계: Mock에서 실패하도록 설정
        let categoriesToUpdate = [
            TDCategory(colorHex: "#ABCDEF", imageName: "update1"),
            TDCategory(colorHex: "#FEDCBA", imageName: "update2")
        ]
        mockRepository.stubbedUpdateCategoriesError = TDDataError.updateEntityFailure

        // Act & Assert 실행 및 검증 단계: UseCase의 execute 호출
        do {
            try await updateCategoriesUseCase.execute(categories: categoriesToUpdate)
            XCTFail("execute() 호출은 실패해야 함")
        } catch let error as TDDataError {
            XCTAssertEqual(error, TDDataError.updateEntityFailure, "에러가 TDDataError.updateEntityFailure여야 함")
        } catch {
            XCTFail("예상치 못한 에러 발생: \(error)")
        }
    }
}
