//
//  Diary.swift
//  toduck
//
//  Created by 승재 on 6/3/24.
//

import Foundation
import UIKit

public struct Time: Hashable {
    public var hour: Int
    public var min: Int
    
    public init(hour: Int = 0, min: Int = 0) {
        self.hour = hour
        self.min = min
    }
}

public enum Emotion: String, CaseIterable, Hashable {
    case happy = "행복"
    case calm = "평온"
    case sad = "슬픔"
    case angry = "화남"
    case anxious = "불안"
    case tired = "피곤"
    
    public var imageName: String {
        switch self {
        case .happy:
            return "happy_image"
        case .calm:
            return "calm_image"
        case .sad:
            return "sad_image"
        case .angry:
            return "angry_image"
        case .anxious:
            return "anxious_image"
        case .tired:
            return "tired_image"
        }
    }
    
    public var imageColor: UIColor {
        switch self {
        case .happy:
            return .systemYellow
        case .calm:
            return .systemBlue
        case .sad:
            return .systemGray
        case .angry:
            return .systemRed
        case .anxious:
            return .systemPurple
        case .tired:
            return .systemOrange
        }
    }
}

public struct Diary: Hashable {
    public let id: Int
    public var focus: Focus
    public var emotion: Emotion
    public var contentText: String
    public let date: Date
    
    public init(id: Int, focus: Focus, emotion: Emotion, contentText: String, date: Date) {
        self.id = id
        self.focus = focus
        self.emotion = emotion
        self.contentText = contentText
        self.date = date
    }
    
    public var emotionImageName: String {
        return emotion.imageName
    }
    
    public var emotionImageColor: UIColor {
        return emotion.imageColor
    }
}