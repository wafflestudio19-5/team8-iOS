//
//  SaveProfile.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/27.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

struct Profile {
    
    var name: String
    var phoneNum: String
    var profileImage: UIImageView
    var location: String
    
}

class SaveProfile {
    
    let nameTfChanged = PublishRelay<String>()
    let imageTfChanged = PublishRelay<UIImageView>()
    let saveBtnTouched = PublishRelay<Void>()
    
    public func signUp (name: String, image: UIImageView) {
        
    }
}
