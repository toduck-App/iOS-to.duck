import Combine
import Foundation
import TDDomain

final class DiaryArchiveViewModel: BaseViewModel {
    enum Input {
        case fetchDiaryList(year: Int, month: Int)
        case deleteDiary(Int)
    }

    enum Output {
        case fetchedDiaryList([Diary])
        case deletedDiary
        case failureAPI(String)
    }

    // MARK: - Properties

    private let fetchDiaryListUseCase: FetchDiaryListUseCase
    private let deleteDiaryUseCase: DeleteDiaryUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var diaryList: [Diary] = []

    // MARK: - Initializer

    init(fetchDiaryListUseCase: FetchDiaryListUseCase, deleteDiaryUseCase: DeleteDiaryUseCase) {
        self.fetchDiaryListUseCase = fetchDiaryListUseCase
        self.deleteDiaryUseCase = deleteDiaryUseCase
    }

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchDiaryList(let year, let month):
                Task { await self?.fetchDiaryList(year: year, month: month) }
            case .deleteDiary(let id):
                Task { await self?.deleteDiary(id: id) }
            }
        }.store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    private func fetchDiaryList(year: Int, month: Int) async {
        do {
            let diaries = try await fetchDiaryListUseCase.execute(year: year, month: month)
            // 날짜순 정렬 (오름차순)
            let sortedDiaries = diaries.sorted { $0.date < $1.date }
            diaryList = sortedDiaries
            output.send(.fetchedDiaryList(sortedDiaries))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }

    private func deleteDiary(id: Int) async {
        do {
            try await deleteDiaryUseCase.execute(id: id)
            output.send(.deletedDiary)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
