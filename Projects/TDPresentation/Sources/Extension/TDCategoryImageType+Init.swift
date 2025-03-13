import TDDomain

extension TDCategoryImageType {
    init(category: TDCategory) {
        self.init(rawValue: category.imageName)
    }
}
