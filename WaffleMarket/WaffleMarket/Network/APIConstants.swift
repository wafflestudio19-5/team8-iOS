//
//  APIConstants.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/27.
//

import Foundation

class APIConstants {
    static let TEST_ON_LOCAL = true
    static let BASE_URL = TEST_ON_LOCAL ? "http://192.168.0.205:8000/api/v1" : "https://www.wafflemarket.shop/api/v1"
    static let WEBSOCKET_URL = TEST_ON_LOCAL ? "http://192.168.0.205:8000/ws" : "https://www.wafflemarket.shop/ws"
}

