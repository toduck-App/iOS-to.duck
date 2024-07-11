//
//  TDColor.swift
//  toduck
//
//  Created by 박효준 on 7/9/24.
//

import Foundation

public enum TDColor {
    public static let baseBlack = ToduckAsset.Colors.baseBlack.color
    public static let baseWhite = ToduckAsset.Colors.baseWhite.color
    
    public enum Neutral {
        public static let neutral50 = ToduckAsset.Colors.neutral50.color
        public static let neutral100 = ToduckAsset.Colors.neutral100.color
        public static let neutral200 = ToduckAsset.Colors.neutral200.color
        public static let neutral300 = ToduckAsset.Colors.neutral300.color
        public static let neutral400 = ToduckAsset.Colors.neutral400.color
        public static let neutral500 = ToduckAsset.Colors.neutral500.color
        public static let neutral600 = ToduckAsset.Colors.neutral600.color
        public static let neutral700 = ToduckAsset.Colors.neutral700.color
        public static let neutral800 = ToduckAsset.Colors.neutral800.color
        public static let neutral900 = ToduckAsset.Colors.neutral900.color
    }

    public enum Primary {
        public static let primary25 = ToduckAsset.Colors.primary25.color
        public static let primary50 = ToduckAsset.Colors.primary50.color
        public static let primary200 = ToduckAsset.Colors.primary200.color
        public static let primary300 = ToduckAsset.Colors.primary300.color
        public static let primary400 = ToduckAsset.Colors.primary400.color
        public static let primary500 = ToduckAsset.Colors.primary500.color
        public static let primary600 = ToduckAsset.Colors.primary600.color
        public static let primary700 = ToduckAsset.Colors.primary700.color
        public static let primary800 = ToduckAsset.Colors.primary800.color
        public static let primary900 = ToduckAsset.Colors.primary900.color
        public static let primary950 = ToduckAsset.Colors.primary950.color
    }
    
    public enum Diary {
        public static let angry = ToduckAsset.Colors.diaryAngryColor.color
        public static let anxiety = ToduckAsset.Colors.diaryAnxietyColor.color
        public static let happy = ToduckAsset.Colors.diaryHappyColor.color
        public static let sad = ToduckAsset.Colors.diarySadColor.color
        public static let soso = ToduckAsset.Colors.diarySosoColor.color
        public static let tired = ToduckAsset.Colors.diaryTiredColor.color
    }

    public enum Timer {
        public static let start = ToduckAsset.Colors.timerStartColor.color
        public static let stop = ToduckAsset.Colors.timerStopColor.color
    }
    
    public enum Semantic {
        public static let error = ToduckAsset.Colors.semanticErrorColor.color
        public static let info = ToduckAsset.Colors.semanticInfoColor.color
        public static let success = ToduckAsset.Colors.semanticSuccessColor.color
        public static let warning = ToduckAsset.Colors.semanticWamingColor.color
    }
}
