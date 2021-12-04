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
    case googleLogin(idToken: String)
}
extension WaffleService: TargetType{
    var baseURL: URL {
        URL(string: "http://ec2-54-180-144-124.ap-northeast-2.compute.amazonaws.com")! // 54.180.144.124
    }
    
    var path: String {
        switch self {
        case .ping:
            return "/ping"
        case .googleLogin(_):
            return "/google-login-test" // MARK: change later
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ping:
            return .get
        case .googleLogin:
            return .post
        }
    }
    
    
    var task: Task {
        switch self {
        case .ping:
            return .requestPlain
        case let .googleLogin(idToken):
            return .requestJSONEncodable(idToken)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

class WaffleAPI{
    static var provider = MoyaProvider<WaffleService>()

    static func ping() -> Single<Response> {
        return provider.rx.request(.ping)
    }
    
    static func googleLogin(idToken: String) -> Single<Response> {
        return provider.rx.request(.googleLogin(idToken: idToken))
    }
}


private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data { Data(self.utf8) }
}
