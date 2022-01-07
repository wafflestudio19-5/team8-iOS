//
//  ArticleAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import Moya
import RxAlamofire
import RxSwift
enum ArticleService {
    case create(title: String, price: String, content: String, category: String)
}
extension ArticleService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/article")!
    }
    
    var path: String {
        switch self {
        case .create:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .create(title, price, content, category):
            return .requestJSONEncodable(["title": title, "price": price, "content": content, "category": category])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .create:
            return ["Content-type": "application/json"]
        }
    }
    
}

class ArticleAPI {
    private static var authPlugin = AuthPlugin()
    private static var provider = MoyaProvider<ArticleService>(plugins: [authPlugin])
    static func create(title: String, price: String, content: String, category: String) -> Single<Response> {
        return provider.rx.request(.create(title: title, price: price, content: content, category: category))
    }
}
