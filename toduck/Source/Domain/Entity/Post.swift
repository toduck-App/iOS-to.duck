//
//  Social.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public enum PostType {
    case communication
    case question
}

public enum PostCategory: String {
    case all = "전체"
    case concentration = "집중력"
    case memory = "기억력"
    case impulse = "충동"
    case anxiety = "불안"
    case sleep = "수면"
}
public struct Post {
    public init(
        id: String,
        user: User,
        contentText: String,
        imageList: [String]?,
        timestamp: Date,
        likeCount: Int?,
        isLike: Bool,
        commentCount: Int?,
        shareCount: Int?,
        routine: Routine?,
        type: PostType,
        category: [PostCategory]?
    ) {
        self.id = id
        self.user = user
        self.contentText = contentText
        self.imageList = imageList
        self.timestamp = timestamp
        self.likeCount = likeCount
        self.isLike = isLike
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.routine = routine
        self.type = type
        self.category = category
    }


    let id: String
    var user: User
    var contentText: String
    var imageList: [String]?
    var timestamp: Date
    
    var likeCount: Int?
    var isLike: Bool
    var commentCount: Int?
    var shareCount: Int?
    var routine: Routine?
    
    //보이지 않는 property
    var type: PostType
    var category: [PostCategory]?
}

