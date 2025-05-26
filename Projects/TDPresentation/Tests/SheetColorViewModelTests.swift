import XCTest
import Combine

import TDCore
import TDDomain
@testable import TDPresentation

final class SheetColorViewModelTests: XCTestCase {
    private var mockFetchCategoriesUseCase: MockFetchCategoriesUseCase!
    private var mockUpdateCategoriesUseCase: MockUpdateCategoriesUseCase!
    private var viewModel: SheetColorViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFetchCategoriesUseCase = MockFetchCategoriesUseCase()
        mockUpdateCategoriesUseCase = MockUpdateCategoriesUseCase()
        viewModel = SheetColorViewModel(
            fetchCategoriesUseCase: mockFetchCategoriesUseCase,
            updateCategoriesUseCase: mockUpdateCategoriesUseCase
        )
        cancellables = []
    }

    override func tearDownWithError() throws {
        mockFetchCategoriesUseCase = nil
        mockUpdateCategoriesUseCase = nil
        viewModel = nil
        cancellables = nil
        try super.tearDownWithError()
    }

    func test_fetchCategories_성공() async throws {
        // Arrange: 가짜 데이터를 설정
        let expectedCategories = [
            TDCategory(colorHex: "#123456", imageName: "test1"),
            TDCategory(colorHex: "#654321", imageName: "test2")
        ]
        mockFetchCategoriesUseCase.stubbedExecuteResult = expectedCategories

        let input = PassthroughSubject<SheetColorViewModel.Input, Never>()
        var receivedOutput: [SheetColorViewModel.Output] = []

        viewModel.transform(input: input.eraseToAnyPublisher())
            .sink { output in
                receivedOutput.append(output)
            }
            .store(in: &cancellables)

        // Act: 카테고리 불러오기 실행
        input.send(.fetchCategories)
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert: 결과 검증
        XCTAssertEqual(receivedOutput, [.fetchedCategories], "출력은 fetchedCategories여야 합니다.")
        XCTAssertEqual(viewModel.categories, expectedCategories, "불러온 카테고리가 예상값과 일치해야 합니다.")
    }

    func test_updateCategoryColor_성공() async throws {
        // Arrange: 기본 카테고리 설정
        let initialCategories = [
            TDCategory(colorHex: "#123456", imageName: "test1"),
            TDCategory(colorHex: "#654321", imageName: "test2")
        ]
        mockFetchCategoriesUseCase.stubbedExecuteResult = initialCategories

        let input = PassthroughSubject<SheetColorViewModel.Input, Never>()
        var receivedOutput: [SheetColorViewModel.Output] = []

        viewModel.transform(input: input.eraseToAnyPublisher())
            .sink { output in
                receivedOutput.append(output)
            }
            .store(in: &cancellables)

        input.send(.fetchCategories)
        try await Task.sleep(nanoseconds: 500_000_000)

        // Act: 카테고리 색상 업데이트
        let indexToUpdate = 1
        let newColor = "#ABCDEF"
        input.send(.updateCategoryColor(indexToUpdate, newColor))

        // Assert: 결과 검증
        XCTAssertEqual(viewModel.categories[indexToUpdate].colorHex, newColor, "카테고리 색상이 새 값으로 업데이트되어야 합니다.")
        XCTAssertEqual(viewModel.categories[indexToUpdate].imageName, "test2", "카테고리 이미지 이름은 변경되지 않아야 합니다.")
    }

    func test_saveCategory_성공() async throws {
        // Arrange: 카테고리 저장 데이터 설정
        let categoriesToSave = [
            TDCategory(colorHex: "#123456", imageName: "test1"),
            TDCategory(colorHex: "#654321", imageName: "test2")
        ]
        mockFetchCategoriesUseCase.stubbedExecuteResult = categoriesToSave
        mockUpdateCategoriesUseCase.stubbedExecuteResult = .success(())

        let input = PassthroughSubject<SheetColorViewModel.Input, Never>()
        var receivedOutput: [SheetColorViewModel.Output] = []

        viewModel.transform(input: input.eraseToAnyPublisher())
            .sink { output in
                receivedOutput.append(output)
            }
            .store(in: &cancellables)

        // Act: 저장 실행
        input.send(.fetchCategories)
        try await Task.sleep(nanoseconds: 500_000_000)
        input.send(.saveCategory)
        try await Task.sleep(nanoseconds: 500_000_000)

        // Assert: 저장 확인
        XCTAssertTrue(mockUpdateCategoriesUseCase.invokedExecute, "카테고리 저장이 호출되어야 합니다.")
        XCTAssertEqual(mockUpdateCategoriesUseCase.invokedExecuteParameters, categoriesToSave, "저장된 카테고리가 입력 값과 일치해야 합니다.")
    }
}
