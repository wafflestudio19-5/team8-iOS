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
    static var userProfile: Profile?
    static func saveTokenForAutoLogin(){
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
    static func login(disposeBag: DisposeBag, _ data: LoginResponse, autologin: Bool = false, completion: @escaping(()->Void)) {
        token = data.token
        if autologin {
            saveTokenForAutoLogin()
        }
        UserAPI.getProfile().subscribe { response in
            print(String(decoding: response.data, as: UTF8.self))
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(ProfileResponse.self, from:response.data){
                self.userProfile = Profile(phoneNumber: decoded.phone_number, userName: decoded.username, profileImageUrl: decoded.profile_image, location: nil)
                
            } else {
                
            }
            completion()
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
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
    static func tryAutologin(disposeBag: DisposeBag, completion: @escaping((Bool)->Void)) -> Bool {
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
            UserAPI.getProfile().subscribe { response in
                print(String(decoding: response.data, as: UTF8.self))
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(ProfileResponse.self, from:response.data){
                    self.userProfile = Profile(phoneNumber: decoded.phone_number, userName: decoded.username, profileImageUrl: decoded.profile_image, location: nil)
                    completion(true)
                } else {
                    print("profile decoding failure")
                    completion(false)
                }
            } onFailure: { error in
                print("profile decoding failure")
            } onDisposed: {
                
            }.disposed(by: disposeBag)

            print("autologin success")
            return true
        } else {
            print("autologin failure")
            completion(false)
            return false
        }
    }
}
