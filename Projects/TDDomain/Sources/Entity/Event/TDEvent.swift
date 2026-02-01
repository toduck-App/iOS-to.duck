import Foundation
import TDCore

public struct TDEvent: Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let start: Date
    public let end: Date
    public let thumbURL: URL?
    public let minAppVersion: String?
    public let isButtonVisible: Bool
    public let buttonText: String?

    public init(
        id: Int,
        name: String,
        start: Date,
        end: Date,
        thumbURL: URL?,
        minAppVersion: String?,
        isButtonVisible: Bool,
        buttonText: String?
    ) {
        self.id = id
        self.name = name
        self.start = start
        self.end = end
        self.thumbURL = thumbURL
        self.minAppVersion = minAppVersion
        self.isButtonVisible = isButtonVisible
        self.buttonText = buttonText
    }
    
   public func isActive(
       reference: Date = Date(),
       currentAppVersion: String = Constant.toduckAppVersion
   ) -> Bool {
       guard reference >= start && reference <= end else { return false }

       if let min = minAppVersion, !min.isEmpty {
           if currentAppVersion.asSemVer < min.asSemVer {
               return false
           }
       }
       return true
   }
}

public extension String {
    var asSemVer: SemVer { SemVer(self) }
}
