import Combine
import Foundation
import TDDomain

final class ToduckViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var isAllDays = true
    private(set) var todaySchedules: [Schedule] = []
    
    var categoryImages: [TDCategoryImageType] {
        todaySchedules.map { TDCategoryImageType.init(rawValue: $0.category.imageName) }
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}
