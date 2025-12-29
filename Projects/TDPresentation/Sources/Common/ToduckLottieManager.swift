import UIKit
import Lottie
import TDDomain

final class ToduckLottieManager {
    static let shared = ToduckLottieManager()

    private init() {}

    func getLottieAnimation(for category: TDCategoryImageType) -> LottieAnimation? {
        let lottieFileName = makeCategoryLottieFileName(for: category)
        let bundle = Bundle(identifier: "to.duck.toduck.design")!

        return LottieAnimation.named(lottieFileName, bundle: bundle)
    }

    func getLottieAnimation(for emotion: Emotion) -> LottieAnimation? {
        let lottieFileName = makeEmotionLottieFileName(for: emotion)
        let bundle = Bundle(identifier: "to.duck.toduck.design")!

        return LottieAnimation.named(lottieFileName, bundle: bundle)
    }

    private func makeCategoryLottieFileName(for category: TDCategoryImageType) -> String {
        switch category {
        case .computer: return "toduckComputer"
        case .vehicle: return "toduckDrive"
        case .medicine: return "toduckMedicine"
        case .pencil: return "toduckPencil"
        case .people: return "toduckPeople"
        case .power: return "toduckPower"
        case .redBook: return "toduckRedbook"
        case .sleep: return "toduckSleep"
        case .talk: return "toduckTalk"
        case .`default`: return "toduckNocategory"
        case .food: return "toduckFood"
        case .heart: return "toduckHeart"
        case .none: return "toduckNoTodo"
        }
    }

    private func makeEmotionLottieFileName(for emotion: Emotion) -> String {
        switch emotion {
        case .happy: return "happy"
        case .good: return "good"
        case .love: return "love"
        case .soso: return "soso"
        case .sick: return "sick"
        case .sad: return "sad"
        case .angry: return "angry"
        case .anxious: return "anxiety"
        case .tired: return "tired"
        }
    }
}
