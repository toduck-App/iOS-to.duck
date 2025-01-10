import UIKit
import TDDesign

extension UIImage {
    static let categoryImages: [UIImage] = [
        TDImage.Category.computer,  // 컴퓨터
        TDImage.Category.food,      // 밥
        TDImage.Category.pencil,    // 연필
        TDImage.Category.redBook,   // 빨간책
        TDImage.Category.yellowBook,// 노란책
        TDImage.Category.sleep,     // 물
        TDImage.Category.power,     // 운동
        TDImage.Category.people,    // 사람
        TDImage.Category.medicine,  // 약
        TDImage.Category.talk,      // 채팅
        TDImage.Category.heart,     // 하트
        TDImage.Category.vehicle,   // 차
        TDImage.Category.none       // None
    ]
    
    static let categoryDictionary: [Int: UIImage] = {
        var dictionary = [Int: UIImage]()
        for (index, image) in categoryImages.enumerated() {
            dictionary[index] = image
        }
        return dictionary
    }()

    static let reverseCategoryDictionary: [UIImage: Int] = {
        var dictionary = [UIImage: Int]()
        for (index, image) in categoryImages.enumerated() {
            dictionary[image] = index
        }
        return dictionary
    }()
}
