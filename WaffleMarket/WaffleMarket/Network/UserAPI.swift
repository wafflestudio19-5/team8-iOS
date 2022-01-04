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
}

extension UserService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/user")!
    }
    
    var path: String {
        switch self {

        case .setProfile:
            return "/profile/"
        }
        
    
    }
    var method: Moya.Method {
        switch self {

        case .setProfile:
            return .put
        }
    }
    
    var task: Task {
        switch self {

            
        case let .setProfile(profile):
            return .requestJSONEncodable(["name": profile.name]) // location? image?
        }
    }
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}


class UserAPI {
    static var provider = MoyaProvider<UserService>()
    

    
    static func setProfile(profile: Profile) -> Single<Response> {
        return provider.rx.request(.setProfile(profile: profile))
    }
}
