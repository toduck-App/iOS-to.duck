//
//  Diary.swift
//  toduck
//
//  Created by 승재 on 6/3/24.
//

import Foundation
import UIKit

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
