//
//  Article.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/07.
//

import Foundation
import UIKit

struct Article {
    var id: Int
    var title: String
    var category: String
    var price: Int?
    var content: String
    var productImages: [String]
    var thumbnailImage: String
    var isSold: Bool
    var likeNum: Int?
    var commentNum: Int?
}
