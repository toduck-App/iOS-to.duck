//
//  TDColor.swift
//  toduck
//
//  Created by 박효준 on 7/9/24.
//

import Foundation

public enum TDColor {
    public static let baseBlack = ToduckAsset.Colors.baseBlack
    public static let baseWhite = ToduckAsset.Colors.baseWhite
    
    public enum Neutral {
        public static let neutral50 = ToduckAsset.Colors.neutral50
        public static let neutral100 = ToduckAsset.Colors.neutral100
        public static let neutral200 = ToduckAsset.Colors.neutral200
        public static let neutral300 = ToduckAsset.Colors.neutral300
        public static let neutral400 = ToduckAsset.Colors.neutral400
        public static let neutral500 = ToduckAsset.Colors.neutral500
        public static let neutral600 = ToduckAsset.Colors.neutral600
        public static let neutral700 = ToduckAsset.Colors.neutral700
        public static let neutral800 = ToduckAsset.Colors.neutral800
        public static let neutral900 = ToduckAsset.Colors.neutral900
    }

    public enum Primary {
        public static let primary25 = ToduckAsset.Colors.primary25
        public static let primary50 = ToduckAsset.Colors.primary50
        public static let primary200 = ToduckAsset.Colors.primary200
        public static let primary300 = ToduckAsset.Colors.primary300
        public static let primary400 = ToduckAsset.Colors.primary400
        public static let primary500 = ToduckAsset.Colors.primary500
        public static let primary600 = ToduckAsset.Colors.primary600
        public static let primary700 = ToduckAsset.Colors.primary700
        public static let primary800 = ToduckAsset.Colors.primary800
        public static let primary900 = ToduckAsset.Colors.primary900
        public static let primary950 = ToduckAsset.Colors.primary950
    }
    
    public enum Diary {
        public static let diaryAngryColor = ToduckAsset.Colors.diaryAngryColor
        public static let diaryAnxietyColor = ToduckAsset.Colors.diaryAnxietyColor
        public static let diaryHappyColor = ToduckAsset.Colors.diaryHappyColor
        public static let diarySadColor = ToduckAsset.Colors.diarySadColor
        public static let diarySosoColor = ToduckAsset.Colors.diarySosoColor
        public static let diaryTiredColor = ToduckAsset.Colors.diaryTiredColor
    }

    public enum Timer {
        public static let timerStartColor = ToduckAsset.Colors.timerStartColor
        public static let timerStopColor = ToduckAsset.Colors.timerStopColor
    }
    
    public enum Semantic {
        public static let semanticErrorColor = ToduckAsset.Colors.semanticErrorColor
        public static let semanticInfoColor = ToduckAsset.Colors.semanticInfoColor
        public static let semanticSuccessColor = ToduckAsset.Colors.semanticSuccessColor
        public static let semanticWamingColor = ToduckAsset.Colors.semanticWamingColor
    }
}
