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
    case create(title: String, price: String, content: String, category: String, productImages: [UIImage])
    case list(page: Int, category: String?, keyword: String?)
    case getComments(articleId: Int)
    case postComment(articleId: Int, content: String)
    case postReply(articleId: Int, commentId: Int, content: String)
    case deleteComment(articleId: Int, commentId: Int)
    case registerBuyer(articleId: Int, buyer_id: Int)
    case like(articleId: Int)
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
        case let .getComments(articleId):
            return "/\(articleId)/comment/"
        case let .postComment(articleId, _):
            return "/\(articleId)/comment/"
        case let .postReply(articleId, commentId, _):
            return "/\(articleId)/comment/\(commentId)/"
        case let .deleteComment(articleId, commentId):
            return "/\(articleId)/comment/\(commentId)/"
        case let .registerBuyer(articleId, _):
            return "/\(articleId)/buyer/"
        case let .like(articleId):
            return "/\(articleId)/like/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .list:
            return .get
        case .getComments:
            return .get
        case .postComment:
            return .post
        case .postReply:
            return .post
        case .deleteComment:
            return .delete
        case .registerBuyer:
            return .put
        case .like:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case let .create(title, price, content, category, productImages):
            var multipart: [MultipartFormData] = []
            var count = 1
            for productImage in productImages {
                let imageData = MultipartFormData(provider: .data(productImage.jpegData(compressionQuality: 0.9)!), name: "image_\(count)", fileName: "image\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
                multipart.append(imageData)
                count += 1
                
            }
            
            let titleData = MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title")
            let priceData = MultipartFormData(provider: .data(price.data(using: .utf8)!), name: "price")
            let contentData = MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
            let categoryData = MultipartFormData(provider: .data(category.data(using: .utf8)!), name: "category")
            let countData = MultipartFormData(provider: .data("\(productImages.count)".data(using: .utf8)!), name: "image_count")
            multipart.append(contentsOf: [titleData, priceData, contentData, categoryData, countData])
            return .uploadMultipart(multipart)
        case let .list(page, category, keyword):
            var dict: [String: String] = [:]
            dict["page"] = "\(page)"
            if let category = category {
                dict["category"] = category
            }
            if let keyword = keyword {
                dict["keyword"] = keyword
            }
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        case .getComments:
            return .requestPlain
        case let .postComment(_, content):
            return .requestJSONEncodable(["content": content])
        case let .postReply(_, _, content):
            return .requestJSONEncodable(["content": content])
        case .deleteComment:
            return .requestPlain
        case let .registerBuyer(articleId, buyer_id):
            return .requestJSONEncodable(["buyer_id": buyer_id])
        case .like:
            return .requestPlain
        }
        
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .create:
            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-type": "application/json"]
        }
    }
    
}

class ArticleAPI {
    private static var authPlugin = AuthPlugin()
    private static var provider = MoyaProvider<ArticleService>(plugins: [authPlugin])
    static func create(title: String, price: String, content: String, category: String, productImages: [UIImage]) -> Observable<ProgressResponse> {
        return provider.rx.requestWithProgress(.create(title: title, price: price, content: content, category: category, productImages: productImages))
    }
    static func list(page: Int, category: String? = nil, keyword: String? = nil) -> Single<Response> {
        return provider.rx.request(.list(page: page, category: category, keyword: keyword))
    }
    static func getComments(articleId: Int) -> Single<Response> {
        return provider.rx.request(.getComments(articleId: articleId))
    }
    static func postComment(articleId: Int, content: String) -> Single<Response> {
        return provider.rx.request(.postComment(articleId: articleId, content: content))
    }
    static func postReply(articleId: Int, commentId: Int, content: String) -> Single<Response> {
        return provider.rx.request(.postReply(articleId: articleId, commentId: commentId, content: content))
    }
    static func deleteComment(articleId: Int, commentId: Int) -> Single<Response> {
        return provider.rx.request(.deleteComment(articleId: articleId, commentId: commentId))
    }
    static func registerBuyer(articleId: Int, buyer_id: Int) -> Single<Response> {
        return provider.rx.request(.registerBuyer(articleId: articleId, buyer_id: buyer_id))
    }
    static func like(articleId: Int) -> Single<Response> {
        return provider.rx.request(.like(articleId: articleId))
    }
}
struct CommentResponse: Codable {
    var id: Int
    var commenter: UserResponse
    var created_at: Double
    var deleted_at: Double?
    var replies: [CommentResponse]?
    var content: String
    var delete_enable: Bool
}
struct UserResponse: Codable {
    var id: Int?
    var username: String
    var profile_image: String?
}
struct LocationResponse: Codable {
    var place_name: String
    var code: String
}
struct ProductImageResponse: Codable {
    var image_url: String
    var thumbnail_url: String
}
struct Article: Codable {
    var id: Int
    var seller: UserResponse
    var location: LocationResponse
    var delete_enable: Bool
    var title: String
    var content: String
    var product_images: [ProductImageResponse]
    var category: String
    var price: Int
    var created_at: Double
    var sold_at: Double?
    var buyer: UserResponse?
    var deleted_at: String?
    var hit: Int?
    var like: Int?
    var user_liked: Bool
}
