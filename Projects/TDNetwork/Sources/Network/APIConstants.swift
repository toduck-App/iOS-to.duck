import Foundation

public enum APIConstants {
    public static let baseURL = Bundle.main.infoDictionary?["SERVER_URL"] as? String ?? "http://localhost:8080"
}
