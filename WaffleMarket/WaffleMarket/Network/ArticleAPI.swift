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
}
extension ArticleService: TargetType {
    var baseURL: URL {
        URL(string: APIConstants.BASE_URL+"/article")!
    }
    
    var path: String {
        switch self {
        case .create:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .create:
            return ["Content-type": "multipart/form-data"]
        }
    }
    
}

class ArticleAPI {
    private static var authPlugin = AuthPlugin()
    private static var provider = MoyaProvider<ArticleService>(plugins: [authPlugin])
    static func create(title: String, price: String, content: String, category: String, productImage: UIImage) -> Observable<ProgressResponse> {
        return provider.rx.requestWithProgress(.create(title: title, price: price, content: content, category: category, productImage: productImage))
    }
}
