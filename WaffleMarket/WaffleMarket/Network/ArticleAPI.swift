//
//  ArticleAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import Moya
import RxAlamofire
import RxSwift
enum ArticleService {
    case create(title: String, price: String, content: String, category: String, productImage: UIImage)
    case list(page: Int, category: String?, keyword: String?)
}
extension ArticleService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/article")!
    }
    
    var path: String {
        switch self {
        case .create:
            return "/"
        case .list:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .list:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .create(title, price, content, category, productImage):
            let imageData = MultipartFormData(provider: .data(productImage.pngData()!), name: "product_image", fileName: "product_image\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            let titleData = MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title")
            let priceData = MultipartFormData(provider: .data(price.data(using: .utf8)!), name: "price")
            let contentData = MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
            let categoryData = MultipartFormData(provider: .data(category.data(using: .utf8)!), name: "category")

            let multipart = [titleData, priceData, contentData, categoryData, imageData]
            return .uploadMultipart(multipart)
        case let .list(page, category, keyword):
            var dict: [String: Any] = [:]
            dict["page"] = page
            if let category = category {
                dict["category"] = category
            }
            if let keyword = keyword {
                dict["keyword"] = keyword
            }
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .create:
            return ["Content-type": "multipart/form-data"]
        case .list:
            return ["Content-type": "application/json"]
        }
    }
    
}

class ArticleAPI {
    private static var authPlugin = AuthPlugin()
    private static var provider = MoyaProvider<ArticleService>(plugins: [authPlugin])
    static func create(title: String, price: String, content: String, category: String, productImage: UIImage) -> Observable<ProgressResponse> {
        return provider.rx.requestWithProgress(.create(title: title, price: price, content: content, category: category, productImage: productImage))
    }
    static func list(page: Int, category: String? = nil, keyword: String? = nil) -> Single<Response> {
        return provider.rx.request(.list(page: page, category: category, keyword: keyword))
    }
}

struct SellerResponse: Codable {
    var username: String
    var profile_image: String
}
struct LocationResponse: Codable {
    var place_name: String
    var code: String
}
struct ProductImageResponse: Codable {
    var url: String
}
struct ArticleResponse: Codable {
    var id: Int
    var seller: SellerResponse
    var location: LocationResponse
    var title: String
    var content: String
    var product_images: [ProductImageResponse]
    var category: String
    var price: Int
    var created_at: String
    var sold_at: String?
    //var buyer: type not defined
    var deleted_at: String?
}
