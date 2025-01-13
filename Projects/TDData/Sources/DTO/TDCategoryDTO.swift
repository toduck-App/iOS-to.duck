import Foundation
import TDDomain

public struct TDCategoryDTO: Codable {
    public let colorHex: String
    public let imageName: String

    public init(
        colorHex: String,
        imageName: String
    ) {
        self.colorHex = colorHex
        self.imageName = imageName
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
