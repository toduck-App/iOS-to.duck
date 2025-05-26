import UIKit
import TDDesign

extension UIImage {
    static let categoryNames: [String] = [
        "COMPUTER",    // 컴퓨터
        "FOOD",        // 밥
        "PENCIL",      // 연필
        "RED_BOOK",    // 빨간책
        "SLEEP",       // 물
        "POWER",       // 운동
        "PEOPLE",      // 사람
        "MEDICINE",    // 약
        "TALK",        // 채팅
        "HEART",       // 하트
        "VEHICLE",     // 차
        "NONE"         // None
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
