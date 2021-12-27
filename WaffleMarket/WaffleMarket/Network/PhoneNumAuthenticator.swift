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
    
    public func sendPw(id: String) -> (success: Bool, phoneNum: String){
        return (true, "")
    }
    
    public func validate(id: String, pw: String) -> (success: Bool, token: String?, phoneNum: String){
        return (true, nil, "")
    }
        
}
