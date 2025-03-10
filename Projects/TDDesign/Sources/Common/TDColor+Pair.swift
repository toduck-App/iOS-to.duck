import UIKit

public typealias TDColorPair = (text: UIColor, back: UIColor)

extension TDColor {
    public static let pair: [UIColor: UIColor] = [
        TDColor.Schedule.text1: TDColor.Schedule.back1,
        TDColor.Schedule.text2: TDColor.Schedule.back2,
        TDColor.Schedule.text3: TDColor.Schedule.back3,
        TDColor.Schedule.text4: TDColor.Schedule.back4,
        TDColor.Schedule.text5: TDColor.Schedule.back5,
        TDColor.Schedule.text6: TDColor.Schedule.back6,
        TDColor.Schedule.text7: TDColor.Schedule.back7,
        TDColor.Schedule.text8: TDColor.Schedule.back8,
        TDColor.Schedule.text9: TDColor.Schedule.back9,
        TDColor.Schedule.text10: TDColor.Schedule.back10,
        TDColor.Schedule.text11: TDColor.Schedule.back11,
        TDColor.Schedule.text12: TDColor.Schedule.back12,
        TDColor.Schedule.text13: TDColor.Schedule.back13,
        TDColor.Schedule.text14: TDColor.Schedule.back14,
        TDColor.Schedule.text15: TDColor.Schedule.back15,
        .white: TDColor.Schedule.back16,
        .white: TDColor.Schedule.back17,
        .white: TDColor.Schedule.back18,
        .white: TDColor.Schedule.back19,
        .white: TDColor.Schedule.back20
    ]
    
    public static let reversedPair: [UIColor: UIColor] = [
        TDColor.Schedule.back1: TDColor.Schedule.text1,
        TDColor.Schedule.back2: TDColor.Schedule.text2,
        TDColor.Schedule.back3: TDColor.Schedule.text3,
        TDColor.Schedule.back4: TDColor.Schedule.text4,
        TDColor.Schedule.back5: TDColor.Schedule.text5,
        TDColor.Schedule.back6: TDColor.Schedule.text6,
        TDColor.Schedule.back7: TDColor.Schedule.text7,
        TDColor.Schedule.back8: TDColor.Schedule.text8,
        TDColor.Schedule.back9: TDColor.Schedule.text9,
        TDColor.Schedule.back10: TDColor.Schedule.text10,
        TDColor.Schedule.back11: TDColor.Schedule.text11,
        TDColor.Schedule.back12: TDColor.Schedule.text12,
        TDColor.Schedule.back13: TDColor.Schedule.text13,
        TDColor.Schedule.back14: TDColor.Schedule.text14,
        TDColor.Schedule.back15: TDColor.Schedule.text15,
        TDColor.Schedule.back16: .white,
        TDColor.Schedule.back17: .white,
        TDColor.Schedule.back18: .white,
        TDColor.Schedule.back19: .white,
        TDColor.Schedule.back20: .white
    ]
    
    static let ColorPair: [Int: TDColorPair] = [
        1: (text: TDColor.Schedule.text1, back: TDColor.Schedule.back1),
        2: (text: TDColor.Schedule.text2, back: TDColor.Schedule.back2),
        3: (text: TDColor.Schedule.text3, back: TDColor.Schedule.back3),
        4: (text: TDColor.Schedule.text4, back: TDColor.Schedule.back4),
        5: (text: TDColor.Schedule.text5, back: TDColor.Schedule.back5),
        6: (text: TDColor.Schedule.text6, back: TDColor.Schedule.back6),
        7: (text: TDColor.Schedule.text7, back: TDColor.Schedule.back7),
        8: (text: TDColor.Schedule.text8, back: TDColor.Schedule.back8),
        9: (text: TDColor.Schedule.text9, back: TDColor.Schedule.back9),
        10: (text: TDColor.Schedule.text10, back: TDColor.Schedule.back10),
        11: (text: TDColor.Schedule.text11, back: TDColor.Schedule.back11),
        12: (text: TDColor.Schedule.text12, back: TDColor.Schedule.back12),
        13: (text: TDColor.Schedule.text13, back: TDColor.Schedule.back13),
        14: (text: TDColor.Schedule.text14, back: TDColor.Schedule.back14),
        15: (text: TDColor.Schedule.text15, back: TDColor.Schedule.back15),
        16: (text: .white, back: TDColor.Schedule.back16),
        17: (text: .white, back: TDColor.Schedule.back17),
        18: (text: .white, back: TDColor.Schedule.back18),
        19: (text: .white, back: TDColor.Schedule.back19),
        20: (text: .white, back: TDColor.Schedule.back20)
    ]
}
