import TDDomain
import Foundation

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
    
    public func fetchDiaryCompareCount(year: Int, month: Int) async throws -> Int {
        try await diaryService.fetchDiaryCompareCount(year: year, month: month)
    }
}
