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
    case getProfile
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
            return "/"
        case .getProfile:
            return "/"
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
        case .getProfile:
            return .get
        case .setCategory:
            return .put
        case .getCategory:
            return .get
            
        }
    }
    
    var task: Task {
        switch self {
        case let .setProfile(profile):
            let imageData = MultipartFormData(provider: .data(profile.profileImage.jpegData(compressionQuality: 0.9)!), name: "profile_image", fileName: "profile_image\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
            let userNameData = MultipartFormData(provider: .data(profile.userName!.data(using: .utf8)!), name: "username")
            let multipartData = [imageData, userNameData]
            return .uploadMultipart(multipartData)
        case .getProfile:
            return .requestPlain
        case let .setCategory(category, enabled):
            return .requestJSONEncodable(SetCategoryRequest(category: category, enabled: enabled))
        case .getCategory:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        switch self{
        case .setProfile:
            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-type": "application/json"]
        }
        
    }
}
struct SetCategoryRequest: Codable{
    var category: String
    var enabled: Bool
}
struct GetCategoryResponse: Codable{
    var category: [String]
}
struct ProfileResponse: Codable{
    var id: Int
    var phone_number: String?
    var username: String
    var profile_image: String
}
class UserAPI {
    static var provider = MoyaProvider<UserService>(plugins: [AuthPlugin()])
    

    
    static func setProfile(profile: Profile) -> Observable<ProgressResponse> {
        return provider.rx.requestWithProgress(.setProfile(profile: profile))
    }
    static func getProfile() -> Single<Response> {
        return provider.rx.request(.getProfile)
    }
    static func setCategory(category: String, enabled: Bool) -> Single<Response>{
        return provider.rx.request(.setCategory(category: category, enabled: enabled))
    }
    
    static func getCategory() -> Single<Response> {
        return provider.rx.request(.getCategory)
    }
}
