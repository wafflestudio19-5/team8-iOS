//
//  UserAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/27.
//

import Foundation
import RxSwift
import RxAlamofire
import Moya
enum UserService{
    
    case setProfile(profile: Profile)
    case setCategory(category: String, enabled: Bool)
    case getCategory
}

extension UserService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/user")!
    }
    
    var path: String {
        switch self {

        case .setProfile:
            return "/profile/"
        case .setCategory:
            return "/category/"
        case .getCategory:
            return "/category/"

    
        }
    }
    var method: Moya.Method {
        switch self {

        case .setProfile:
            return .put
        case .setCategory:
            return .put
        case .getCategory:
            return .get
            
        }
    }
    
    var task: Task {
        switch self {
        case let .setProfile(profile):
            return .requestJSONEncodable(["name": profile.name]) // location? image?
        case let .setCategory(category, enabled):
            return .requestJSONEncodable(SetCategoryRequest(category: category, enabled: enabled))
        case .getCategory:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        return ["Content-type": "application/json", "Authorization": AccountManager.token ?? "no auth"]
    }
}
struct SetCategoryRequest: Codable{
    var category: String
    var enabled: Bool
}
struct GetCategoryResponse: Codable{
    var categories: [String]
}
class UserAPI {
    static var provider = MoyaProvider<UserService>()
    

    
    static func setProfile(profile: Profile) -> Single<Response> {
        return provider.rx.request(.setProfile(profile: profile))
    }
    static func setCategory(category: String, enabled: Bool) -> Single<Response>{
        return provider.rx.request(.setCategory(category: category, enabled: enabled))
    }
    
    static func getCategory() -> Single<Response> {
        return provider.rx.request(.getCategory)
    }
}
