import Foundation

public enum MFTask {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestParameters(parameters: Parameters)
}
