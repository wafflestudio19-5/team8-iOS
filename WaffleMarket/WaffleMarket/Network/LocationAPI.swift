//
//  LocationAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/06.
//

import Foundation
import Moya
import RxAlamofire
import RxSwift

enum LocationService {
    case postLocation(code: String)
    case findNearbyNeighborhoods(code: String)
}

extension LocationService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/location")!
    }
    var path: String {
        switch self {
        case .postLocation:
            return "/"
        case let .findNearbyNeighborhoods(code):
            return "/\(code)/neighborhood/" // MARK: change later
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .postLocation:
            return .post
        case .findNearbyNeighborhoods:
            return .get

        }
    }
    
    
    var task: Task {
        switch self {
        case let .postLocation(code):
            return .requestJSONEncodable(["location_code": code])
        case .findNearbyNeighborhoods:
            return .requestPlain // MARK: change "code" later
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

class LocationAPI {
    private static var authPlugin = AuthPlugin()
    private static var provider = MoyaProvider<LocationService>(plugins: [authPlugin])
    static func postLocation(code: String) -> Single<Response> {
        return provider.rx.request(.postLocation(code: code))
    }
    
    static func findNearbyNeighborhoods(code: String) -> Single<Response> {
        return provider.rx.request(.findNearbyNeighborhoods(code: code))
    }
}
struct Neighborhood: Codable {
    var place_name: String
    var code: String
}


