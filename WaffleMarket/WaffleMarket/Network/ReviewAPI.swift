//
//  ReviewAPI.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/29.
//

import Foundation
import Moya
import RxAlamofire
import RxSwift
enum ReviewService {
    case reviewAsBuyer(articleId: Int, review: String)
    case reviewAsSeller(articleId: Int, review: String)
    case getReceived(articleId: Int)
    case getSent(articleId: Int)
    case delete(articleId: Int)
    case getGoodManner(userId: Int)
    case getBadManner(userId: Int)
    case getManner(userId: Int)
    case updateManner(userId: Int, type: String, mannerList: [String])
    case getReviewAndManner(userId: Int)
}
extension ReviewService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/review")!
    }
    
    var path: String {
        switch self {
        case let .reviewAsBuyer(articleId, _):
            return "/article/\(articleId)/buyer/"
        case let .reviewAsSeller(articleId, _):
            return "/article/\(articleId)/seller/"
        case let .getReceived(articleId):
            return "/article/\(articleId)/received/"
        case let .getSent(articleId):
            return "/article/\(articleId)/sent/"
        case let .delete(articleId):
            return "/article/\(articleId)/sent/"
        case let .getGoodManner(userId):
            return "/user/\(userId)/manner/good/"
        case let .getBadManner(userId):
            return "/user/\(userId)/manner/bad/"
        case let .getManner(userId):
            return "/user/\(userId)/manner/"
        case let .updateManner(userId, type, _):
            return "/user/\(userId)/manner/\(type)/"
        case let .getReviewAndManner(userId):
            return "/user/\(userId)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reviewAsBuyer:
            return .post
        case .reviewAsSeller:
            return .post
        case .getReceived:
            return .get
        case .getSent:
            return .get
        case .delete:
            return .delete
        case .getGoodManner:
            return .get
        case .getBadManner:
            return .get
        case .getManner:
            return .get
        case .updateManner:
            return .put
        case .getReviewAndManner:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .reviewAsBuyer(_, review):
            return .requestJSONEncodable(["review": review])
        case let .reviewAsSeller(_, review):
            return .requestJSONEncodable(["review": review])
        case .getReceived:
            return .requestPlain
        case .getSent:
            return .requestPlain
        case .delete:
            return .requestPlain
        case .getGoodManner:
            return .requestPlain
        case .getBadManner:
            return .requestPlain
        case .getManner:
            return .requestPlain
        case let .updateManner(_, _, mannerList):
            return .requestJSONEncodable(["manner_list": mannerList])
        case .getReviewAndManner:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

struct ReviewResponse: Decodable {
    var review: String
    var evaluation: String
    var type: String
}
struct MannerResponse: Decodable {
    var manner: [String: Int]
}

class ReviewAPI {
    static let provider = MoyaProvider<ReviewService>(plugins: [AuthPlugin()])
    static func reviewAsBuyer(articleId: Int, review: String) -> Single<Response> {
        return provider.rx.request(.reviewAsBuyer(articleId: articleId, review: review))
    }
    static func reviewAsSeller(articleId: Int, review: String) -> Single<Response> {
        return provider.rx.request(.reviewAsSeller(articleId: articleId, review: review))
    }
    static func getReceived(articleId: Int) -> Single<Response> {
        return provider.rx.request(.getReceived(articleId: articleId))
    }
    static func getSent(articleId: Int) -> Single<Response> {
        return provider.rx.request(.getSent(articleId: articleId))
    }
    static func delete(articleId: Int) -> Single<Response> {
        return provider.rx.request(.delete(articleId: articleId))
    }
    static func getBadManner(userId: Int) -> Single<Response> {
        return provider.rx.request(.getBadManner(userId: userId))
    }
    static func getGoodManner(userId: Int) -> Single<Response> {
        return provider.rx.request(.getGoodManner(userId: userId))
    }
    static func getManner(userId: Int) -> Single<Response> {
        return provider.rx.request(.getManner(userId: userId))
    }
    static func updateManner(userId: Int, type: String, mannerList: [String]) -> Single<Response> {
        return provider.rx.request(.updateManner(userId: userId, type: type, mannerList: mannerList))
    }
    static func getReviewAndManner(userId: Int) -> Single<Response> {
        return provider.rx.request(.getReviewAndManner(userId: userId))
    }
}
