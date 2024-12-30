import Combine

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
