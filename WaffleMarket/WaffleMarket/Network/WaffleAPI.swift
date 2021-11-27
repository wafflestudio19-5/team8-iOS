//
//  WaffleAPI.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/27.
//

import Foundation
import RxSwift
import RxAlamofire
class WaffleAPI{
    static let baseURL = "http://127.0.0.1:8000/api/v1"
    static func ping() -> Observable<(HTTPURLResponse, Any)> {
        return RxAlamofire.requestJSON(.get, "\(baseURL)/ping")
    }
}
