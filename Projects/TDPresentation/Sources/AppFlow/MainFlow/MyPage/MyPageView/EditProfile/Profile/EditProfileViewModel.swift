import Combine
import Foundation
import TDDomain

final class EditProfileViewModel: BaseViewModel {
    enum Input {
        case writeNickname(nickname: String)
        case writeProfileImage(image: Data)
        case updateProfile
    }
    
    enum Output {
        case updatedProfile
        case failureAPI(String)
    }
    
    private let updateProfileImageUseCase: UpdateProfileImageUseCase
    private let updateUserNicknameUseCase: UpdateUserNicknameUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var nickName: String = ""
    private var preNickName: String = ""
    private var profileImage: Data?
    private var isEnableUpdateButton: Bool {
        !nickName.isEmpty
    }
    
    init(
        updateUserNicknameUseCase: UpdateUserNicknameUseCase,
        updateProfileImageUseCase: UpdateProfileImageUseCase,
        nickName: String = ""
    ) {
        self.updateUserNicknameUseCase = updateUserNicknameUseCase
        self.updateProfileImageUseCase = updateProfileImageUseCase
        self.preNickName = nickName
        self.nickName = nickName
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .writeNickname(let nickname):
                nickName = nickname
            case .writeProfileImage(let image):
                profileImage = image
            case .updateProfile:
                Task { await self.updateProfile() }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateProfile() async {
        do {
            if nickName != preNickName {
                try await updateUserNicknameUseCase.execute(nickname: nickName)
                preNickName = nickName
            }
            
            let fileName = UUID().uuidString + ".jpg"
            if let profileImage {
                let image: (fileName: String, imageData: Data)? = (fileName: fileName, imageData: profileImage)
                try await updateProfileImageUseCase.execute(image: image)
            } else {
                try await updateProfileImageUseCase.execute(image: nil)
            }
            
            output.send(.updatedProfile)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
}
