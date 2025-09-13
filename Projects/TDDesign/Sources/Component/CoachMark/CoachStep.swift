import UIKit

public struct CoachStep {
    let targetProvider: () -> UIView?
    let title: String
    let icon: UIImage?
    let iconSize: CGSize
    let description: String
    let highlightTokens: [String]
    let preferredDirection: CoachArrowDirection?
    let cornerRadius: CGFloat
    let onEnter: (() -> Void)?
    let allowBackgroundTapToAdvance: Bool?

    let centerImage: UIImage?
    let centerImageMaxWidth: CGFloat?
    let centerImageYOffset: CGFloat?

    public init(targetProvider: @escaping () -> UIView?,
                title: String,
                icon: UIImage? = nil,
                iconSize: CGSize = CGSize(width: 24, height: 24),
                description: String,
                highlightTokens: [String] = [],
                preferredDirection: CoachArrowDirection? = nil,
                cornerRadius: CGFloat = 12,
                onEnter: (() -> Void)? = nil,
                allowBackgroundTapToAdvance: Bool? = nil,
                centerImage: UIImage? = nil,
                centerImageMaxWidth: CGFloat? = nil,
                centerImageYOffset: CGFloat? = nil)
    {
        self.targetProvider = targetProvider
        self.title = title
        self.icon = icon
        self.iconSize = iconSize
        self.description = description
        self.highlightTokens = highlightTokens
        self.preferredDirection = preferredDirection
        self.cornerRadius = cornerRadius
        self.onEnter = onEnter
        self.allowBackgroundTapToAdvance = allowBackgroundTapToAdvance
        self.centerImage = centerImage
        self.centerImageMaxWidth = centerImageMaxWidth
        self.centerImageYOffset = centerImageYOffset
    }
}
