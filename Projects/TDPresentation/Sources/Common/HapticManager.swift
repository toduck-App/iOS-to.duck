import UIKit

enum HapticManager {

    /// 충격(Impact) 햅틱을 발생시킵니다.
    ///
    /// 사용자의 직접적인 상호작용 (버튼 탭, 카드 드래그 등)에 적합한 햅틱입니다.
    ///
    /// - Parameter style: 햅틱의 강도를 결정하는 스타일입니다. 기본값은 `.light`입니다.
    ///   - `.light`: 가벼운 진동
    ///   - `.medium`: 중간 정도 진동
    ///   - `.heavy`: 강한 진동
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    /// 시스템 알림(Notification) 햅틱을 발생시킵니다.
    ///
    /// 작업의 결과(성공, 실패, 경고 등)를 사용자에게 전달할 때 적합한 햅틱입니다.
    ///
    /// - Parameter type: 알림 유형에 따른 햅틱 스타일입니다.
    ///   - `.success`: 성공 알림 (부드러운 진동)
    ///   - `.warning`: 경고 알림 (중간 강도)
    ///   - `.error`: 오류 알림 (강한 진동)
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    /// 선택(Selection) 변경에 적합한 햅틱을 발생시킵니다.
    ///
    /// 피커, 세그먼트, 탭 선택 등 작은 선택 변화에 사용됩니다.
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
