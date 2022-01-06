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
    case startAuth(phoneNumber: String)
    case completeAuth(phoneNumber: String, authNumber: String)
    case signup(phoneNumber: String, userName: String)
    case googleLogin(idToken: [String: String])
}
extension WaffleService: TargetType{
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL)! //54.180.144.124
    }
    
    var path: String {
        switch self {
        case .ping:
            return "/ping"
        case .startAuth:
            return "/authenticate/"
        case .completeAuth:
            return "/authenticate/"
        case .signup:
            return "/signup/"
        case .googleLogin(_):
            return "/login/google/" // MARK: change later
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .ping:
            return .get
        case .startAuth:
            return .post
        case .completeAuth:
            return .put
        case .signup:
            return .post
        case .googleLogin:
            return .post


        }
    }
    
    
    var task: Task {
        switch self {
        case .ping:
            return .requestPlain
        case let .startAuth(phoneNumber):
            return .requestJSONEncodable(["phone_number": phoneNumber])
        case let .completeAuth(phoneNumber, authNumber):
            return .requestJSONEncodable(["phone_number": phoneNumber, "auth_number": authNumber])
        case let .signup(phoneNumber, userName):
            return .requestJSONEncodable(["phone_number": phoneNumber, "username": userName])
        case let .googleLogin(idToken):
            return .requestJSONEncodable(idToken)

        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

struct LoginResponse: Codable {
    var username: String?
    var phone_number: String?
    var logined: Bool?
    var first_login: Bool?
    
    var token: String
    var location_exists: Bool
}

struct StartAuthResponse: Codable{
    var phone_number: String
    var auth_number: Int?
}

struct CompleteAuthResponse: Codable {
    var authenticated: Bool
}



class WaffleAPI{
    private static var provider = MoyaProvider<WaffleService>()

    static func ping() -> Single<Response> {
        return provider.rx.request(.ping)
    }
    static func startAuth(phoneNumber: String) -> Single<Response>{
        return provider.rx.request(.startAuth(phoneNumber: phoneNumber))
    }
    
    static func completeAuth(phoneNumber: String, authNumber: String) -> Single<Response> {
        return provider.rx.request(.completeAuth(phoneNumber: phoneNumber, authNumber: authNumber))
    }
    
    static func signup(phoneNumber: String, userName: String) -> Single<Response> {
        return provider.rx.request(.signup(phoneNumber: phoneNumber, userName: userName))
    }
    
    static func googleLogin(idToken: String) -> Single<Response> {
        return provider.rx.request(.googleLogin(idToken: ["token": idToken]))
    }
    

}


private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data { Data(self.utf8) }
}
