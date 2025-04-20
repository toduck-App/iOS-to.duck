import UIKit

public typealias TDColorPair = (text: UIColor, back: UIColor)

extension TDColor {
    public static let opacityPair: [ColorValue: UIColor] = [
        ColorValue(color: TDColor.Schedule.back1): TDColor.ScheduleOpacity.back1,
        ColorValue(color: TDColor.Schedule.back2): TDColor.ScheduleOpacity.back2,
        ColorValue(color: TDColor.Schedule.back3): TDColor.ScheduleOpacity.back3,
        ColorValue(color: TDColor.Schedule.back4): TDColor.ScheduleOpacity.back4,
        ColorValue(color: TDColor.Schedule.back5): TDColor.ScheduleOpacity.back5,
        ColorValue(color: TDColor.Schedule.back6): TDColor.ScheduleOpacity.back6,
        ColorValue(color: TDColor.Schedule.back7): TDColor.ScheduleOpacity.back7,
        ColorValue(color: TDColor.Schedule.back8): TDColor.ScheduleOpacity.back8,
        ColorValue(color: TDColor.Schedule.back9): TDColor.ScheduleOpacity.back9,
        ColorValue(color: TDColor.Schedule.back10): TDColor.ScheduleOpacity.back10,
        ColorValue(color: TDColor.Schedule.back11): TDColor.ScheduleOpacity.back11,
        ColorValue(color: TDColor.Schedule.back12): TDColor.ScheduleOpacity.back12,
        ColorValue(color: TDColor.Schedule.back13): TDColor.ScheduleOpacity.back13,
        ColorValue(color: TDColor.Schedule.back14): TDColor.ScheduleOpacity.back14,
        ColorValue(color: TDColor.Schedule.back15): TDColor.ScheduleOpacity.back10,
        ColorValue(color: TDColor.Schedule.back16): .white,
        ColorValue(color: TDColor.Schedule.back17): .white,
        ColorValue(color: TDColor.Schedule.back18): .white,
        ColorValue(color: TDColor.Schedule.back19): .white,
        ColorValue(color: TDColor.Schedule.back20): .white
    ]
    
    public static let reversedOpacityFrontPair: [ColorValue: UIColor] = [
        ColorValue(color: TDColor.ScheduleOpacity.back1): TDColor.Schedule.text1,
        ColorValue(color: TDColor.ScheduleOpacity.back2): TDColor.Schedule.text2,
        ColorValue(color: TDColor.ScheduleOpacity.back3): TDColor.Schedule.text3,
        ColorValue(color: TDColor.ScheduleOpacity.back4): TDColor.Schedule.text4,
        ColorValue(color: TDColor.ScheduleOpacity.back5): TDColor.Schedule.text5,
        ColorValue(color: TDColor.ScheduleOpacity.back6): TDColor.Schedule.text6,
        ColorValue(color: TDColor.ScheduleOpacity.back7): TDColor.Schedule.text7,
        ColorValue(color: TDColor.ScheduleOpacity.back8): TDColor.Schedule.text8,
        ColorValue(color: TDColor.ScheduleOpacity.back9): TDColor.Schedule.text9,
        ColorValue(color:  TDColor.ScheduleOpacity.back10): TDColor.Schedule.text10,
        ColorValue(color:  TDColor.ScheduleOpacity.back11): TDColor.Schedule.text11,
        ColorValue(color:  TDColor.ScheduleOpacity.back12): TDColor.Schedule.text12,
        ColorValue(color:  TDColor.ScheduleOpacity.back13): TDColor.Schedule.text13,
        ColorValue(color:  TDColor.ScheduleOpacity.back14): TDColor.Schedule.text14,
    ]
    
    public static let reversedOpacityBackPair: [ColorValue: UIColor] = [
        ColorValue(color: TDColor.ScheduleOpacity.back1): TDColor.Schedule.back1,
        ColorValue(color: TDColor.ScheduleOpacity.back2): TDColor.Schedule.back2,
        ColorValue(color: TDColor.ScheduleOpacity.back3): TDColor.Schedule.back3,
        ColorValue(color: TDColor.ScheduleOpacity.back4): TDColor.Schedule.back4,
        ColorValue(color: TDColor.ScheduleOpacity.back5): TDColor.Schedule.back5,
        ColorValue(color: TDColor.ScheduleOpacity.back6): TDColor.Schedule.back6,
        ColorValue(color: TDColor.ScheduleOpacity.back7): TDColor.Schedule.back7,
        ColorValue(color: TDColor.ScheduleOpacity.back8): TDColor.Schedule.back8,
        ColorValue(color: TDColor.ScheduleOpacity.back9): TDColor.Schedule.back9,
        ColorValue(color:  TDColor.ScheduleOpacity.back10): TDColor.Schedule.back10,
        ColorValue(color:  TDColor.ScheduleOpacity.back11): TDColor.Schedule.back11,
        ColorValue(color:  TDColor.ScheduleOpacity.back12): TDColor.Schedule.back12,
        ColorValue(color:  TDColor.ScheduleOpacity.back13): TDColor.Schedule.back13,
        ColorValue(color:  TDColor.ScheduleOpacity.back14): TDColor.Schedule.back14,
    ]
    
    public static let colorPair: [Int: TDColorPair] = [
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
    
    public static let colorCheckBox: [ColorValue: UIImage] = [
        ColorValue(color: TDColor.ScheduleOpacity.back1):  TDImage.CheckBox.back1,
        ColorValue(color: TDColor.ScheduleOpacity.back2):  TDImage.CheckBox.back2,
        ColorValue(color: TDColor.ScheduleOpacity.back3):  TDImage.CheckBox.back3,
        ColorValue(color: TDColor.ScheduleOpacity.back4):  TDImage.CheckBox.back4,
        ColorValue(color: TDColor.ScheduleOpacity.back5):  TDImage.CheckBox.back5,
        ColorValue(color: TDColor.ScheduleOpacity.back6):  TDImage.CheckBox.back6,
        ColorValue(color: TDColor.ScheduleOpacity.back7):  TDImage.CheckBox.back7,
        ColorValue(color: TDColor.ScheduleOpacity.back8):  TDImage.CheckBox.back8,
        ColorValue(color: TDColor.ScheduleOpacity.back9):  TDImage.CheckBox.back9,
        ColorValue(color: TDColor.ScheduleOpacity.back10): TDImage.CheckBox.back10,
        ColorValue(color: TDColor.ScheduleOpacity.back11): TDImage.CheckBox.back11,
        ColorValue(color: TDColor.ScheduleOpacity.back12): TDImage.CheckBox.back12,
        ColorValue(color: TDColor.ScheduleOpacity.back13): TDImage.CheckBox.back13,
        ColorValue(color: TDColor.ScheduleOpacity.back14): TDImage.CheckBox.back14,
    ]
}
