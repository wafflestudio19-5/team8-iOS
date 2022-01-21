//
//  Comment.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/08.
//

import Foundation
struct Comment{
    var id: Int
    var username: String
    var profile_image: String
    var timestamp: Int
    var content: String
    var isReply: Bool
    var deletable: Bool
    var commenter_id: Int
}
