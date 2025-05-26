import LinkPresentation

final class ProfileShareItem: NSObject, UIActivityItemSource {
    private let url: URL
    private let title: String
    private let icon: UIImage

    init(url: URL, title: String, icon: UIImage) {
        self.url = url
        self.title = title
        self.icon = icon
        super.init()
    }

    // 1) 기본 placeholder
    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        url
    }

    // 2) 실제 공유할 아이템
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        title + "\n" + url.absoluteString
    }

    // 3) 공유 시트 상단에 표시될 제목 (메일, 메시지 등에서 subject 역할)
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        title
    }

    // 4) Link Presentation 메타데이터 (iOS13+)
    func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.originalURL = url
        metadata.url = url
        metadata.iconProvider = NSItemProvider(object: icon)
        metadata.imageProvider = NSItemProvider(object: icon)
        return metadata
    }
}
