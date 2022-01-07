//
//  LocationModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/23.
//

import Foundation
class Address: CustomStringConvertible {
    let code: String
    let name: String
    init(_ code: String, _ name: String){
        self.code = code
        self.name = name
    }
    
    var description: String {
        return "{code: \(self.code), name: \(self.name)}"
    }
}
