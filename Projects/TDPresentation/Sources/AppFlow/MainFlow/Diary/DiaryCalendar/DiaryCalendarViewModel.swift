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
    var selectedDate: Date?
    
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
            guard let currentDiary = monthDiaryList[selectedDate ?? Date()] else {
                throw NSError(domain: "Diary not found", code: 404, userInfo: nil)
            }
            let existingImageCount = currentDiary.diaryImageUrls?.count ?? 0
            
            // 기존 이미지가 1개일 때만 1장만 추가 가능
            if existingImageCount + images.count > 2 {
                output.send(.failureAPI("기존 이미지가 있어서 최대 2장까지만 첨부할 수 있습니다."))
                return
            }
            
            let newImageTuples = images.map { ("\(UUID().uuidString).jpg", $0) }
            
            let updatedDiary = Diary(
                id: currentDiary.id,
                date: currentDiary.date,
                emotion: currentDiary.emotion,
                title: currentDiary.title,
                memo: currentDiary.memo,
                diaryImageUrls: currentDiary.diaryImageUrls
            )
            
            try await updateDiaryUseCase.execute(isChangeEmotion: false, diary: updatedDiary, image: newImageTuples)
            output.send(.setImage)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func fetchDiaryList(year: Int, month: Int) async {
        do {
            let diaryList = try await fetchDiaryListUseCase.execute(year: year, month: month)
            let diaryItems = diaryList.map {
                Diary(
                    id: $0.id,
                    date: $0.date,
                    emotion: $0.emotion,
                    title: $0.title,
                    memo: $0.memo,
                    diaryImageUrls: $0.diaryImageUrls
                )
            }
            monthDiaryList = Dictionary(uniqueKeysWithValues: diaryItems.map { ($0.date.normalized, $0) })
            selectedDiary = monthDiaryList[selectedDate ?? Date()]
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
