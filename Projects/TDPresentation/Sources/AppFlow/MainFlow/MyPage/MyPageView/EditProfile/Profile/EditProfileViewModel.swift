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
        case failureNickname(String)
        case failureAPI(String)
    }
    
    private let updateProfileImageUseCase: UpdateProfileImageUseCase
    private let updateUserNicknameUseCase: UpdateUserNicknameUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var nickName: String = ""
    private var preNickName: String = ""
    private var profileImage: Data?
    private var isProfileImageUpdated = false
    
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
                self.nickName = nickname
            case .writeProfileImage(let image):
                self.profileImage = image
                self.isProfileImageUpdated = true
            case .updateProfile:
                Task { await self.updateProfile() }
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func updateProfile() async {
        guard isValidNickname(nickName) else {
            output.send(.failureNickname("닉네임에는 띄어쓰기나 특수문자를 사용할 수 없어요."))
            return
        }
        
        do {
            // 닉네임이 이전과 다를 경우에만 업데이트
            if nickName != preNickName {
                try await updateUserNicknameUseCase.execute(nickname: nickName)
                preNickName = nickName
            }
            
            // 프로필 이미지를 수정한 경우에만 업데이트 수행
            if isProfileImageUpdated, let profileImage {
                let fileName = UUID().uuidString + ".jpg"
                let image: (fileName: String, imageData: Data)? = (fileName: fileName, imageData: profileImage)
                try await updateProfileImageUseCase.execute(image: image)
            }
            
            output.send(.updatedProfile)
        } catch {
            output.send(.failureAPI(error.localizedDescription))
        }
    }
    
    private func isValidNickname(_ nickname: String) -> Bool {
        let regex = "^[가-힣a-zA-Z0-9]{2,8}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
    }
}
