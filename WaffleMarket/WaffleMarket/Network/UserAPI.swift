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
    case startAuth(phoneNumber: String)
    case completeAuth(phoneNumber: String, authNumber: String)
    case googleLogin(idToken: [String: String])
    case setProfile(profile: Profile)
}

extension UserService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/user")!
    }
    
    var path: String {
        switch self {
        case .startAuth:
            return "/authenticate/"
        case .completeAuth:
            return "/authenticate/"
        case .googleLogin(_):
            return "/google-login-test/" // MARK: change later
        case .setProfile:
            return "/profile/"
        }
        
    
    }
    var method: Moya.Method {
        switch self {
        case .startAuth:
            return .post
        case .completeAuth:
            return .put
        case .googleLogin:
            return .post
        case .setProfile:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case let .startAuth(phoneNumber):
            return .requestJSONEncodable(["phone_number": phoneNumber])
        case let .completeAuth(phoneNumber, authNumber):
            return .requestJSONEncodable(["phone_number": phoneNumber, "auth_number": authNumber])
        case let .googleLogin(idToken):
            return .requestJSONEncodable(idToken)
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
    
    static func startAuth(phoneNumber: String) -> Single<Response>{
        return provider.rx.request(.startAuth(phoneNumber: phoneNumber))
    }
    
    static func completeAuth(phoneNumber: String, authNumber: String) -> Single<Response> {
        return provider.rx.request(.completeAuth(phoneNumber: phoneNumber, authNumber: authNumber))
    }
    
    static func googleLogin(idToken: String) -> Single<Response> {
        return provider.rx.request(.googleLogin(idToken: ["token": idToken]))
    }
    
    static func setProfile(profile: Profile) -> Single<Response> {
        return provider.rx.request(.setProfile(profile: profile))
    }
}
