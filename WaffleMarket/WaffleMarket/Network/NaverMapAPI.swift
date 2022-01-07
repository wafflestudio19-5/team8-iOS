//
//  NaverAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/21.
//

import Foundation
import RxSwift
import RxAlamofire
import Moya

enum NaverMapService {
    case geocodeWithCoordinate(query: String, coordinate: String)
    case geocode(query: String)
    case reverseGeocode(coords: String)
}
extension NaverMapService: TargetType {
    var headers: [String : String]? {
        return ["X-NCP-APIGW-API-KEY-ID": Bundle.main.object(forInfoDictionaryKey: "NMFClientId") as! String,
                "X-NCP-APIGW-API-KEY": Bundle.main.object(forInfoDictionaryKey: "NMFClientSecret") as! String]
    }
    var baseURL: URL { URL(string:"https://naveropenapi.apigw.ntruss.com")! }
    var path: String {
        switch self {
        case .geocodeWithCoordinate, .geocode:
            return "/map-geocode/v2/geocode"
        
        case .reverseGeocode:
            return "/map-reversegeocode/v2/gc"
        }
    }
    var method: Moya.Method {
        switch self {
        case .geocodeWithCoordinate, .geocode:
            return .get
        case .reverseGeocode:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .geocodeWithCoordinate(query, coordinate):
            return .requestParameters(parameters: ["query": query, "coordinate": coordinate], encoding: URLEncoding.queryString)
        case let .geocode(query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        case let .reverseGeocode(coords):
            return .requestParameters(parameters: ["coords": coords, "output": "json"], encoding: URLEncoding.queryString)
        }
    }
}

class AddressResponse: Codable {
    var roadAddress: String = ""
    var jibunAddress: String = ""
    var englishAddress: String = ""
}

class GeocodeResponse: Codable {
    var status: String = ""
    var errorMessage: String? = ""
    var meta: [String: Int] = [:]
    var addresses: [AddressResponse] = []
}

struct ReverseGeocodeResponseResult: Decodable {
    var name: String = ""
    var id: String = ""
    enum CodingKeys: String, CodingKey{
        case code
        case id
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let code = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .code)
        self.id = try code.decode(String.self, forKey: .id)
        
    }
}
struct ReverseGeocodeResponse: Decodable {
    
    var results: [ReverseGeocodeResponseResult] = []
}

class NaverMapAPI {
    private static var provider = MoyaProvider<NaverMapService>()
    static func geocode(query: String, longitude: Double? = nil, latitude: Double? = nil) -> Single<Response> {
        var coordinate = ""
        if longitude == nil || latitude == nil {
            coordinate = ""
            return provider.rx.request(.geocode(query: query))
        } else {
            coordinate = "\(longitude!),\(latitude!)"
            return provider.rx.request(.geocodeWithCoordinate(query: query, coordinate: coordinate))
        }
        
    }
    static func reverseGeocode(longitude: Double, latitude: Double) -> Single<Response> {
        return provider.rx.request(.reverseGeocode(coords: "\(longitude),\(latitude)"))
    }
}
