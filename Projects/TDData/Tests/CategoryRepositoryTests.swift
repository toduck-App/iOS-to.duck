import XCTest
import TDData
@testable import TDCore
@testable import TDDomain

final class CategoryRepositoryTests: XCTestCase {
    private var mockStorage: MockCategoryStorage!
    private var repository: CategoryRepositoryImpl!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockStorage = MockCategoryStorage()
        repository = CategoryRepositoryImpl(storage: mockStorage)
    }
    
    override func tearDownWithError() throws {
        mockStorage = nil
        repository = nil
        try super.tearDownWithError()
    }
    
    func test_카테고리_가져오기_성공() async throws {
        // Arrange 준비 단계
        let expectedCategories = [
            TDCategoryDTO(colorHex: "#123456", imageName: "test1"),
            TDCategoryDTO(colorHex: "#654321", imageName: "test2")
        ]
        mockStorage.stubbedFetchCategoriesResult = expectedCategories
        
        // Act 실행 단계
        let categories = try await repository.fetchCategories()
        
        // Assert 검증 단계
        XCTAssertEqual(categories.count, 2, "가져온 카테고리의 개수가 맞아야 함")
        XCTAssertEqual(categories[0].colorHex, "#123456", "첫 번째 카테고리 색상 확인")
        XCTAssertEqual(categories[0].imageName, "test1", "첫 번째 카테고리 이미지 확인")
        XCTAssertEqual(categories[1].colorHex, "#654321", "두 번째 카테고리 색상 확인")
        XCTAssertEqual(categories[1].imageName, "test2", "두 번째 카테고리 이미지 확인")
    }
    
    func test_카테고리_가져오기_실패() async throws {
        // Arrange 준비 단계
        mockStorage.stubbedFetchCategoriesError = TDDataError.fetchEntityFaliure

        // Act & Assert 실행 및 검증 단계
        do {
            _ = try await repository.fetchCategories()
            XCTFail("fetchCategories가 실패해야 함") // 실패 시 오류를 던져야 하므로 여기에 도달하면 안 됨
        } catch let error as TDDataError {
            XCTAssertEqual(error, TDDataError.fetchEntityFaliure, "에러가 TDDataError.fetchEntityFaliure여야 함")
        } catch {
            XCTFail("예상치 못한 에러 발생: \(error)")
        }
    }
    
    func test_카테고리_업데이트_성공() async throws {
        // Arrange 준비 단계
        let categoriesToUpdate = [
            TDCategory(colorHex: "#ABCDEF", imageName: "update1"),
            TDCategory(colorHex: "#FEDCBA", imageName: "update2")
        ]
        mockStorage.stubbedUpdateCategoriesResult = .success(())
        
        // Act 실행 단계
        let result = try await repository.updateCategories(categories: categoriesToUpdate)
        
        // Assert 검증 단계
        switch result {
        case .success:
            XCTAssertTrue(true, "카테고리 업데이트가 성공했어야 함")
        case .failure:
            XCTFail("카테고리 업데이트가 성공하지 않음")
        }
    }
    
    func test_카테고리_업데이트_실패() async throws {
        // Arrange 준비 단계
        let categoriesToUpdate = [
            TDCategory(colorHex: "#ABCDEF", imageName: "update1"),
            TDCategory(colorHex: "#FEDCBA", imageName: "update2")
        ]
        mockStorage.stubbedUpdateCategoriesError = TDDataError.updateEntityFailure

        // Act & Assert 실행 및 검증 단계
        do {
            _ = try await repository.updateCategories(categories: categoriesToUpdate)
            XCTFail("updateCategories가 실패해야 함") // 실패 시 오류를 던져야 하므로 여기에 도달하면 안 됨
        } catch let error as TDDataError {
            XCTAssertEqual(error, TDDataError.updateEntityFailure, "에러가 TDDataError.updateEntityFailure여야 함")
        } catch {
            XCTFail("예상치 못한 에러 발생: \(error)")
        }
    }
}
