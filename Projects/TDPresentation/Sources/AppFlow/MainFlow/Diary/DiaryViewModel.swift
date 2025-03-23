import Combine
import TDDomain
import Foundation

final class DiaryViewModel: BaseViewModel {
    enum Input {
        
    }
    
    enum Output {
        
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var todayDiary: Diary? = Diary(
        id: 0,
        date: Date(),
        emotion: .angry,
        title: "ㅁㄴㅇ",
        contentText: "12312312213\n123152363246\n1325135",
        imagesURL: [""]
    )
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        
        return output.eraseToAnyPublisher()
    }
}

