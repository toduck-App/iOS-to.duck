import UIKit
import TDDesign

extension UIImage {
    static let categoryNames: [String] = [
        "computer",   // 컴퓨터
        "food",       // 밥
        "pencil",     // 연필
        "redBook",    // 빨간책
        "sleep",      // 물
        "power",      // 운동
        "people",     // 사람
        "medicine",   // 약
        "talk",       // 채팅
        "heart",      // 하트
        "vehicle",    // 차
    ]
    
    static let categoryImages: [UIImage] = [
        TDImage.Category.computer,
        TDImage.Category.food,
        TDImage.Category.pencil,
        TDImage.Category.redBook,
        TDImage.Category.sleep,
        TDImage.Category.power,
        TDImage.Category.people,
        TDImage.Category.medicine,
        TDImage.Category.talk,
        TDImage.Category.heart,
        TDImage.Category.vehicle,
    ]
    
    static let categoryDictionary: [String: UIImage] = {
        var dictionary = [String: UIImage]()
        for (index, image) in categoryImages.enumerated() {
            dictionary[categoryNames[index]] = image
        }
        return dictionary
    }()

    static let reverseCategoryDictionary: [UIImage: String] = {
        var dictionary = [UIImage: String]()
        for (index, image) in categoryImages.enumerated() {
            dictionary[image] = categoryNames[index]
        }
        return dictionary
    }()
}
