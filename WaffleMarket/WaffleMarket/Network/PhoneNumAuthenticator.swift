//
//  LoginViewModel.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire


class PhoneNumAuthenticator {
    
    let idTfChanged = PublishRelay<String>()
    let pwTfChanged = PublishRelay<String>()
    let loginBtnTouched = PublishRelay<Void>()
    
    public func sendPw(id: String) -> (success: Bool, phoneNum: String){
        return (true, "")
    }
    
    public func validate(id: String, pw: String) -> (login: Bool, token: String?, success: Bool, phoneNum: String){
        return (true, nil, true, "")
    }
        
}
