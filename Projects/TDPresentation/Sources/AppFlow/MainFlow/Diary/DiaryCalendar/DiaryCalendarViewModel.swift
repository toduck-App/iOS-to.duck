import Combine
import TDDomain
import Foundation

final class DiaryCalendarViewModel: BaseViewModel {
    enum Input {
        case selectDay(Date)
        case fetchDiaryList(Int, Int)
        case deleteDiary(Int)
        case setImages([Data])
    }
    
    enum Output {
        case selectedDiary(Diary)
        case setImage
        case fetchedDiaryList
        case deletedDiary
        case notFoundDiary
        case failureAPI(String)
    }
    
    private let fetchDiaryListUseCase: FetchDiaryListUseCase
    private let updateDiaryUseCase: UpdateDiaryUseCase
    private let deleteDiaryUseCase: DeleteDiaryUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var monthDiaryList = [Date: Diary]()
    var selectedDiary: Diary?
    
    init(
        fetchDiaryListUseCase: FetchDiaryListUseCase,
        updateDiaryUseCase: UpdateDiaryUseCase,
        deleteDiaryUseCase: DeleteDiaryUseCase
    ) {
        self.fetchDiaryListUseCase = fetchDiaryListUseCase
        self.updateDiaryUseCase = updateDiaryUseCase
        self.deleteDiaryUseCase = deleteDiaryUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectDay(let date):
                self?.selecteDay(date: date)
            case .setImages(let datas):
                Task { await self?.setImages(datas) }
            case .fetchDiaryList(let year, let month):
                Task { await self?.fetchDiaryList(year: year, month: month) }
            case .deleteDiary(let id):
                Task { await self?.deleteDiary(id: id) }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func selecteDay(date: Date) {
        selectedDiary = monthDiaryList[date.normalized]
        if let selectedDiary = selectedDiary {
            output.send(.selectedDiary(selectedDiary))
        } else {
            output.send(.notFoundDiary)
        }
    }
    
    private func setImages(_ images: [Data]) async {
        if images.count > 2 {
            output.send(.failureAPI("이미지는 최대 2개까지 첨부 가능합니다."))
            return
        }
        
        do {
            guard let selectedDiary else { return }
            
            let image = images.map { ("\(UUID().uuidString).jpg", $0) }
            try await updateDiaryUseCase.execute(isChangeEmotion: false, diary: selectedDiary, image: image)
            output.send(.setImage)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func fetchDiaryList(year: Int, month: Int) async {
        do {
            let diaryList = try await fetchDiaryListUseCase.execute(year: year, month: month)
            let diaryItems = diaryList.map { Diary(id: $0.id, date: $0.date, emotion: $0.emotion, title: $0.title, memo: $0.memo, diaryImageUrls: $0.diaryImageUrls) }
            monthDiaryList = Dictionary(uniqueKeysWithValues: diaryItems.map { ($0.date.normalized, $0) })
            output.send(.fetchedDiaryList)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func deleteDiary(id: Int) async {
        do {
            try await deleteDiaryUseCase.execute(id: id)
            monthDiaryList.removeValue(forKey: selectedDiary?.date.normalized ?? Date())
            output.send(.deletedDiary)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
