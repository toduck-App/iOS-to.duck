import Foundation
import TDCore
import TDDomain
import WidgetKit

public final class DiaryRepositoryImpl: DiaryRepository {
    private let diaryService: DiaryService
    private let awsService: AwsService
    
    public init(diaryService: DiaryService, awsService: AwsService) {
        self.diaryService = diaryService
        self.awsService = awsService
    }
    
    public func createDiary(diary: Diary, image: [(fileName: String, imageData: Data)]?) async throws {
        var imageUrls: [String] = []
        if let image {
            for (fileName, imageData) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: imageData)
                imageUrls.append(urls.fileUrl.absoluteString)
            }
        }
        
        var diary = DiaryPostRequestDTO(diary: diary)
        diary.diaryImageUrls = imageUrls
        
        try await diaryService.createDiary(diary: diary)
        Task {
            // MARK: 휴대폰 기기가 느려서, 일기 작성 후 바로 스트릭을 조회하면, 서버에서 반영이 안된 상태로 조회되는 경우가 있을 수도 있음.
            try? await Task.sleep(until: .now + .seconds(1))

            _ = try await fetchStreak()
        }
    }
    
    public func fetchDiaryList(year: Int, month: Int) async throws -> [Diary] {
        let response = try await diaryService.fetchDiaryList(year: year, month: month)
        
        return response.convertToDiaryList()
    }
    
    public func updateDiary(isChangeEmotion: Bool, diary: TDDomain.Diary, image: [(fileName: String, imageData: Data)]?) async throws {
        var imageUrls: [String] = diary.diaryImageUrls ?? []
        if let image {
            for (fileName, imageData) in image {
                let urls = try await awsService.requestPresignedUrl(fileName: fileName)
                try await awsService.requestUploadImage(url: urls.presignedUrl, data: imageData)
                imageUrls.append(urls.fileUrl.absoluteString)
            }
        }
        
        var diary = DiaryPatchRequestDTO(isChangeEmotion: isChangeEmotion, diary: diary)
        diary.diaryImageUrls = imageUrls
        
        try await diaryService.updateDiary(diary: diary)
    }
    
    public func deleteDiary(id: Int) async throws {
        try await diaryService.deleteDiary(id: id)
    }
    
    public func fetchDiaryCompareCount(yearMonth: String) async throws -> Int {
        try await diaryService.fetchDiaryCompareCount(yearMonth: yearMonth)
    }
    
    // 일기 스트릭 조회 성공, 해당 유저의 일기 스트릭과 최근에 작성한 일기 날짜를 반환합니다.
    public func fetchStreak() async throws -> (streak: Int, lastWriteDate: String?) {
        let response = try await diaryService.fetchStreak()
        
        let streak = response.streak
        let lastDiaryDate = response.lastDiaryDate

        UserDefaults(suiteName: UserDefaultsConstant.Diary.suiteName)?.setValue(streak, forKey: UserDefaultsConstant.Diary.countKey)
        UserDefaults(suiteName: UserDefaultsConstant.Diary.suiteName)?.setValue(lastDiaryDate, forKey: UserDefaultsConstant.Diary.lastWriteDateKey)
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetConstant.diary.kindIdentifier)
        return (streak, lastDiaryDate)
    }
}
