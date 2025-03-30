public struct RegisterUser {
    public let phoneNumber: String
    public let loginId: String
    public let password: String
    
    public init(
        phoneNumber: String,
        loginId: String,
        password: String
    ) {
        self.phoneNumber = phoneNumber
        self.loginId = loginId
        self.password = password
    }
}
