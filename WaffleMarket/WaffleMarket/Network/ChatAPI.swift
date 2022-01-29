//
//  ChatAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/22.
//

import Foundation
import RxSwift
import RxAlamofire
import Moya

enum ChatService {
    case create(article_id: Int)
    case listByUser
    case listByArticle(article_id: Int)
    case leave(roomname: String)
}
extension ChatService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL + "/chat")!
    }
    
    var path: String {
        switch self {
        case .create:
            return "/"
        case .listByUser:
            return "/"
        case let .listByArticle(article_id):
            return "/\(article_id)/"
        case let .leave(roomname):
            return "/\(roomname)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .listByUser:
            return .get
        case .listByArticle:
            return .get
        case .leave:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .create(article_id):
            return .requestJSONEncodable(["article_id": article_id])
        case .listByUser:
            return .requestPlain
        case .listByArticle:
            return .requestPlain
        case .leave:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
    
}

struct ChatroomResponse: Decodable {
    var roomname: String
    var username: String
    var location: LocationResponse?
    var profile_image: String?
    var article_id: Int?
    var product_image: ProductImageResponse?
}



class ChatAPI {
    static let provider = MoyaProvider<ChatService>(plugins: [AuthPlugin()])
    static func create(article_id: Int) -> Single<Response> {
        return provider.rx.request(.create(article_id: article_id))
    }
    static func listByUser() -> Single<Response> {
        return provider.rx.request(.listByUser)
    }
    static func listByArticle(article_id: Int) -> Single<Response> {
        return provider.rx.request(.listByArticle(article_id: article_id))
    }
    static func leave(roomName: String) -> Single<Response> {
        return provider.rx.request(.leave(roomname: roomName))
    }
}
