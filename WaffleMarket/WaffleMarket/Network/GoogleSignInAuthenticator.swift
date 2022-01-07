//
//  GoogleLogin.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/04.
//

import Foundation
import GoogleSignIn
import RxSwift

class GoogleSignInAuthenticator{
    public static let sharedInstance = GoogleSignInAuthenticator()
    private let clientID = "1057727434742-u4mdqv91qb01dvlpu7eqgbk8h37k616k.apps.googleusercontent.com"
    private lazy var configuration: GIDConfiguration = {
        return GIDConfiguration(clientID: clientID)
    }()
    
    public func signIn(presenting: UIViewController, disposeBag: DisposeBag, onSuccess: @escaping ((LoginResponse)->Void), onFailure: (@escaping (_ error: Error) -> Void) = {_ in }){
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: presenting) { googleUser, error in
            guard error == nil else { return }
            guard let googleUser = googleUser else { return }
            googleUser.authentication.do { authentication, error in
                
                guard error == nil else {
                    
                    onFailure(error!)
                    
                    return
                }
                guard let authentication = authentication else { return }
                guard let idToken = authentication.idToken else { return }
                WaffleAPI.googleLogin(idToken: idToken).subscribe { response in
                    guard response.statusCode/100 == 2 else {
                        print("Google Login statusCode:", response.statusCode)
                        presenting.toast("로그인에 실패했어요")
                        return
                    }
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(LoginResponse.self, from: response.data) {
                        onSuccess(decoded)
                    } else {
                        presenting.toast("로그인에 실패했어요")
                    }
                    
                
                } onFailure: { error in
                    
                    onFailure(error)
                    
                } onDisposed: {
                    
                }.disposed(by: disposeBag)
            }
        }
    }
    
    public func signOut(){
        GIDSignIn.sharedInstance.signOut()
    }
}
