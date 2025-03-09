import Foundation
import TDDomain

public struct TDCategoryDTO: Codable {
    private let colorHex: String
    private let imageName: String

    public init(
        colorHex: String,
        imageName: String
    ) {
        self.colorHex = colorHex
        self.imageName = imageName
    }
    
    public init(from category: TDCategory) {
        self.colorHex = category.colorHex
        self.imageName = category.imageName
    }
}

extension TDCategoryDTO {
    func convertToTDCategory() -> TDCategory {
        return TDCategory(
            colorHex: self.colorHex,
            imageName: self.imageName
        )
    }
}
