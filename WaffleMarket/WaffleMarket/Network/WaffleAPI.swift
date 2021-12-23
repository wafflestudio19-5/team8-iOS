//
//  WaffleAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/27.
//

import Foundation
import RxSwift
import RxAlamofire
import Moya
enum WaffleService{
    case ping
    case googleLogin(idToken: [String: String])
    case postLocation(code: Int)
}
extension WaffleService: TargetType{
    var baseURL: URL {
        URL(string: "http://ec2-54-180-144-124.ap-northeast-2.compute.amazonaws.com/api/v1")! //54.180.144.124
    }
    
    var path: String {
        switch self {
        case .ping:
            return "/ping"
        case .googleLogin(_):
            return "/google-login-test/" // MARK: change later
        case .postLocation:
            return "/location/"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .ping:
            return .get
        case .googleLogin:
            return .post
        case .postLocation:
            return .post
        }
    }
    
    
    var task: Task {
        switch self {
        case .ping:
            return .requestPlain
        case let .googleLogin(idToken):
            return .requestJSONEncodable(idToken)
        case let .postLocation(code):
            return .requestJSONEncodable(["code": code])
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

class WaffleAPI{
    private static var provider = MoyaProvider<WaffleService>()

    static func ping() -> Single<Response> {
        return provider.rx.request(.ping)
    }
    
    static func googleLogin(idToken: String) -> Single<Response> {
        return provider.rx.request(.googleLogin(idToken: ["token": idToken]))
    }
    
    static func postLocation(code: Int) -> Single<Response> {
        return provider.rx.request(.postLocation(code: code))
    }
}


private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data { Data(self.utf8) }
}
