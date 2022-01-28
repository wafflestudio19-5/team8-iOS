//
//  AccountManager.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/06.
//

import Foundation
import UIKit
import RxSwift
class AccountManager {
    static var token: String?
    static var userProfile: Profile!
    static func saveTokenForAutoLogin(){
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(userProfile)
        UserDefaults.standard.set(encoded, forKey: "userProfile")
        let keychainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: "com.wafflestudio.team8.WaffleMarket",
            kSecAttrAccount: "userToken",
            kSecValueData: token!.data(using: .utf8, allowLossyConversion: false)!
        ]
        SecItemDelete(keychainQuery)
        let status: OSStatus = SecItemAdd(keychainQuery, nil)
        assert(status == noErr, "failed to save jwt token: \(status)")
    }
    static func login(disposeBag: DisposeBag, _ data: LoginResponse, autologin: Bool = false) {
        token = data.token
        userProfile = Profile(id: data.user.id, phoneNumber: data.user.phone_number, userName: data.user.username, profileImageUrl: data.user.profile_image, location: nil, temperature: data.user.temparature)
        if autologin {
            saveTokenForAutoLogin()
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
        UserDefaults.standard.removeObject(forKey: "userProfile")
    }
    static func tryAutologin(disposeBag: DisposeBag) -> Bool {
        let keychainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "com.wafflestudio.team8.WaffleMarket",
            kSecAttrAccount: "userToken",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: .utf8)
            token = value
            if let savedValue = UserDefaults.standard.object(forKey: "userProfile") as? Data{
                let decoder = JSONDecoder()
                if let userProfile = try? decoder.decode(Profile.self, from: savedValue) {
                    self.userProfile = userProfile
                    print("autologin success")
                    return true
                }
            }
            print("autologin failure")
            return false
        } else {
            print("autologin failure")
            
            return false
        }
    }
}
