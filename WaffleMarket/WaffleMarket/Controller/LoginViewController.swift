//
//  LoginViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import GoogleSignIn

class LoginViewController: UIViewController {
    var googleLoginBtn = GIDSignInButton()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        googleLoginBtn.rx.controlEvent(.touchUpInside).bind{
            GoogleSignInAuthenticator.sharedInstance.signIn(presenting: self, disposeBag: self.disposeBag) {
                print("success")
            }
        }.disposed(by: disposeBag)
        self.view.addSubview(googleLoginBtn)
        setLoginBtn()
        
        // Do any additional setup after loading the view.
    }
    private func setLoginBtn(){
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        googleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleLoginBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
