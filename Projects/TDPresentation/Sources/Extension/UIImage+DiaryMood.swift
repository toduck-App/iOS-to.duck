import UIKit
import TDDesign

extension UIImage {
    static let diaryMoods: [String] = [
        "LOVE",   // 사랑
        "HAPPY",  // 기쁨
        "GOOD",   // 좋음
        "SOSO",   // 보통
        "SICK",   // 아픔
        "SAD",    // 슬픔
        "TIRED",  // 지침
        "ANXIOUS",// 불안
        "ANGRY",  // 화남
    ]
    
    // 무드 이미지 배열
    static let moodImages: [UIImage] = [
        TDImage.Mood.love,      // 사랑
        TDImage.Mood.happy,     // 기쁨
        TDImage.Mood.good,      // 좋음
        TDImage.Mood.soso,      // 보통
        TDImage.Mood.sick,      // 아픔
        TDImage.Mood.sad,       // 슬픔
        TDImage.Mood.tired,     // 지침
        TDImage.Mood.anxious,   // 불안
        TDImage.Mood.angry,     // 화남
    ]
    
    // 무드와 이미지 간의 매핑 딕셔너리
    static let moodDictionary: [String: UIImage] = {
        var dictionary = [String: UIImage]()
        for (index, image) in moodImages.enumerated() {
            dictionary[diaryMoods[index]] = image
        }
        return dictionary
    }()

    // 이미지와 무드 간의 매핑 딕셔너리
    static let reverseMoodDictionary: [UIImage: String] = {
        var dictionary = [UIImage: String]()
        for (index, image) in moodImages.enumerated() {
            dictionary[image] = diaryMoods[index]
        }
        return dictionary
    }()
}
