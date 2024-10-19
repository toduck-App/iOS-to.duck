//
//  Comment.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public struct Comment {
    public init(id: Int, user: User, content: String, timestamp: Date, isLike: Bool, like: Int?) {
        self.id = id
        self.user = user
        self.content = content
        self.timestamp = timestamp
        self.isLike = isLike
        self.like = like
    }
    
    let id: Int
    var user: User
    var content: String
    var timestamp: Date
    var isLike: Bool
    var like: Int?
}
