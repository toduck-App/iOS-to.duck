import Combine
import TDDomain
import Foundation

final class DiaryViewModel: BaseViewModel {
    enum Input {
        case fetchUserNickname
        case fetchDiaryCompareCount
        case fetchFocusPercent
    }
    
    enum Output {
        case fetchedUserNickname(String)
        case fetchedCompareCount(Int)
        case fetchedFocusPercent(Int)
        case failureAPI(String)
    }
    
    private let fetchUserNicknameUseCase: FetchUserNicknameUseCase
    private let fetchDiaryCompareCountUseCase: FetchDiaryCompareCountUseCase
    private let fetchFocusPercentUseCase: FetchFocusPercentUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var monthDiaryList = [Date: Diary]()
    var selectedDiary: Diary?
    
    init(
        fetchUserNicknameUseCase: FetchUserNicknameUseCase,
        fetchDiaryCompareCountUseCase: FetchDiaryCompareCountUseCase,
        fetchFocusPercentUseCase: FetchFocusPercentUseCase
    ) {
        self.fetchUserNicknameUseCase = fetchUserNicknameUseCase
        self.fetchDiaryCompareCountUseCase = fetchDiaryCompareCountUseCase
        self.fetchFocusPercentUseCase = fetchFocusPercentUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchUserNickname:
                Task { await self?.fetchUserNickname() }
            case .fetchDiaryCompareCount:
                Task { await self?.fetchDiaryCompareCount() }
            case .fetchFocusPercent:
                Task { await self?.fetchFocusPercent() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchUserNickname() async {
        do {
            let nickname = try await fetchUserNicknameUseCase.execute()
            output.send(.fetchedUserNickname(nickname))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func fetchDiaryCompareCount() async {
        do {
            let currentDate = Date()
            let year = Calendar.current.component(.year, from: currentDate)
            let month = Calendar.current.component(.month, from: currentDate)
            let count = try await fetchDiaryCompareCountUseCase.execute(year: year, month: month)
            output.send(.fetchedCompareCount(count))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func fetchFocusPercent() async {
        do {
            let yearMonth = getCurrentYearMonth()
            let focusPercent = try await fetchFocusPercentUseCase.execute(yearMonth: yearMonth)
            output.send(.fetchedFocusPercent(focusPercent))
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func getCurrentYearMonth() -> String {
        let currentDate = Date()
        let year = Calendar.current.component(.year, from: currentDate)
        let month = Calendar.current.component(.month, from: currentDate)
        return String(format: "%04d-%02d", year, month)
    }
}
