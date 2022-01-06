//
//  AccountManager.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/06.
//

import Foundation
import UIKit
class AccountManager {
    static var token: String?
    static func login(_ data: LoginResponse, autologin: Bool = false) {
        token = data.token
        if autologin {
            let keychainQuery: NSDictionary = [
                kSecClass : kSecClassGenericPassword,
                kSecAttrService: "com.wafflestudio.team8.WaffleMarket",
                kSecAttrAccount: "userToken",
                kSecValueData: data.token.data(using: .utf8, allowLossyConversion: false)!
            ]
            SecItemDelete(keychainQuery)
            let status: OSStatus = SecItemAdd(keychainQuery, nil)
            assert(status == noErr, "failed to save jwt token: \(status)")
        }
    }
    static func logout() {
        let keychainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "com.wafflestudio.team8.WaffleMarket",
            kSecAttrAccount: "userToken"
        ]
        let status = SecItemDelete(keychainQuery)
        if status != errSecItemNotFound {
            assert(status == noErr, "failed to delete jwt token: \(status)")
        }
    }
    static func tryAutologin() -> Bool {
        let keychainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "com.wafflestudio.team8.WaffleMarket",
            kSecAttrAccount: "userToken",
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: .utf8)
            token = value
            print("autologin success")
            return true
        } else {
            print("autologin failure")
            return false
        }
    }
}
