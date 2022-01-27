//
//  APIConstants.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/27.
//

import Foundation

class APIConstants {
    static let TEST_ON_LOCAL = false
    static let BASE_URL = TEST_ON_LOCAL ? "http://localhost:8000/api/v1" : "https://www.wafflemarket.shop/api/v1"
    static let WEBSOCKET_URL = TEST_ON_LOCAL ? "ws://localhost:8000/ws" : "ws://www.wafflemarket.shop:8001/ws"
}

