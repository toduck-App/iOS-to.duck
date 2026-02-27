import Combine
import Foundation

final class InquiryViewModel: BaseViewModel {
    enum Input {
        case chipSelect(at: Int)
        case setContent(String)
        case setImages([Data])
        case submitInquiry
    }

    enum Output {
        case canSubmit(Bool)
        case setImage
        case failure(String)
    }

    enum InquiryType: String, CaseIterable {
        case bugReport = "오류 / 버그 신고"
        case usageInquiry = "이용 문의"
        case improvement = "앱 개선 제안"
        case other = "기타"
    }

    // MARK: - State

    private(set) var selectedType: InquiryType?
    private(set) var content: String = ""
    private(set) var images: [Data] = []
    private(set) var canSubmit: Bool = false

    // MARK: - Private

    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Transform

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .chipSelect(let index):
                    setType(at: index)
                case .setContent(let text):
                    setContent(text)
                case .setImages(let data):
                    setImages(data)
                case .submitInquiry:
                    break // TODO: API 연동
                }
            }
            .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

private extension InquiryViewModel {
    func setType(at index: Int) {
        selectedType = InquiryType.allCases[index]
        validate()
    }

    func setContent(_ text: String) {
        content = text
        validate()
    }

    func setImages(_ images: [Data]) {
        guard images.count <= 5 else {
            output.send(.failure("이미지는 최대 5개까지 첨부 가능합니다."))
            return
        }
        self.images = images
        output.send(.setImage)
    }

    func validate() {
        canSubmit = selectedType != nil && !content.isEmpty
        output.send(.canSubmit(canSubmit))
    }
}
