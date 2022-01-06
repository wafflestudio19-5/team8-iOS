//
//  AuthPlugin.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/06.
//

import Foundation
import Moya
struct AuthPlugin: PluginType {
  

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
      request.addValue("JWT " + AccountManager.token!, forHTTPHeaderField: "Authorization")
    return request
  }
}
