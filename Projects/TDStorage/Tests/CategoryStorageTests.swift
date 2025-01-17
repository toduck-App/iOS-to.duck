import XCTest
@testable import TDStorage
@testable import TDData
import TDCore
import TDDomain

final class CategoryStorageTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var categoryStorage: CategoryStorageImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // 테스트용 UserDefaults 인스턴스 생성
        userDefaults = UserDefaults(suiteName: "CategoryStorageTests")
        userDefaults.removePersistentDomain(forName: "CategoryStorageTests")
        categoryStorage = CategoryStorageImpl(userDefaults: userDefaults)
    }

    override func tearDownWithError() throws {
        categoryStorage = nil
        userDefaults.removePersistentDomain(forName: "CategoryStorageTests")
        userDefaults = nil
        try super.tearDownWithError()
    }

    func test_데이터가_없을_때_기본값_반환() async throws {
        // Arrange 준비 단계: 테스트 대상 시스템(SUT)와 의존성을 원하는 상태로 만들기
        // UserDefaults에 데이터를 저장하지 않은 상태로 초기화
        userDefaults.removeObject(forKey: "categoryColors")
        
        // Act 실행 단계: SUT 메소드를 호출하면서 의존성을 전달해서 결과를 저장하기
        let categories = try await categoryStorage.fetchCategories()
        
        // Assert 검증 단계: 결과와 기대치를 비교해서 검증하기
        XCTAssertEqual(categories.count, 13, "기본값 배열의 크기가 맞아야 함")
        XCTAssertEqual(categories[0].colorHex, "#FFD6E2", "첫 번째 기본값 색상 확인")
        XCTAssertEqual(categories[0].imageName, "computer", "첫 번째 기본값 이미지 확인")
    }

    func test_UserDefaults에_저장된_데이터_반환() async throws {
        // Arrange 준비 단계: 테스트 대상 시스템(SUT)와 의존성을 원하는 상태로 만들기
        // 예상되는 카테고리 데이터를 UserDefaults에 저장
        let expectedCategories = [
            TDCategoryDTO(colorHex: "#123456", imageName: "customImage1"),
            TDCategoryDTO(colorHex: "#654321", imageName: "customImage2")
        ]
        let encoder = JSONEncoder()
        let data = try encoder.encode(expectedCategories)
        userDefaults.set(data, forKey: "categoryColors")
        
        // Act 실행 단계: SUT 메소드를 호출하면서 의존성을 전달해서 결과를 저장하기
        let categories = try await categoryStorage.fetchCategories()
        
        // Assert 검증 단계: 결과와 기대치를 비교해서 검증하기
        XCTAssertEqual(categories.count, 2, "저장된 데이터 배열의 크기가 맞아야 함")
        XCTAssertEqual(categories[0].colorHex, "#123456", "저장된 첫 번째 색상 확인")
        XCTAssertEqual(categories[0].imageName, "customImage1", "저장된 첫 번째 이미지 확인")
        XCTAssertEqual(categories[1].colorHex, "#654321", "저장된 두 번째 색상 확인")
        XCTAssertEqual(categories[1].imageName, "customImage2", "저장된 두 번째 이미지 확인")
    }

    func test_카테고리_데이터를_UserDefaults에_업데이트() async throws {
        // Arrange 준비 단계: 테스트 대상 시스템(SUT)와 의존성을 원하는 상태로 만들기
        // 새로운 카테고리 데이터를 생성
        let categoriesToSave = [
            TDCategoryDTO(colorHex: "#ABCDEF", imageName: "newImage1"),
            TDCategoryDTO(colorHex: "#FEDCBA", imageName: "newImage2")
        ]
        
        // Act 실행 단계: SUT 메소드를 호출하면서 의존성을 전달해서 결과를 저장하기
        let result = try await categoryStorage.updateCategories(categories: categoriesToSave)
        
        // Assert 검증 단계: 결과와 기대치를 비교해서 검증하기
        switch result {
        case .success:
            XCTAssertTrue(true, "카테고리 업데이트가 성공했어야 함")
        case .failure(let error):
            XCTFail("카테고리 업데이트 실패: \(error)")
        }
        
        // 저장된 데이터 확인
        let data = userDefaults.data(forKey: "categoryColors")
        XCTAssertNotNil(data, "UserDefaults에 데이터가 저장되어야 함")

        let decoder = JSONDecoder()
        let savedCategories = try decoder.decode([TDCategoryDTO].self, from: data!)
        XCTAssertEqual(savedCategories.count, 2, "저장된 데이터 배열의 크기가 맞아야 함")
        XCTAssertEqual(savedCategories[0].colorHex, "#ABCDEF", "저장된 첫 번째 색상 확인")
        XCTAssertEqual(savedCategories[0].imageName, "newImage1", "저장된 첫 번째 이미지 확인")
        XCTAssertEqual(savedCategories[1].colorHex, "#FEDCBA", "저장된 두 번째 색상 확인")
        XCTAssertEqual(savedCategories[1].imageName, "newImage2", "저장된 두 번째 이미지 확인")
    }
}
