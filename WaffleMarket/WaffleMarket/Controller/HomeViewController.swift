//
//  RootViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/25.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    var helloWorldLabel = UILabel()
    var signOutBtn = UIButton(type:.system) // MARK: this is for test. remove later
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        self.view.addSubview(helloWorldLabel)
        self.view.addSubview(signOutBtn)
        setHelloWorldLabel()
        setSignOutBtn()
    }
    
    private func setHelloWorldLabel(){
        helloWorldLabel.text = "Home!"
        helloWorldLabel.textAlignment = .center
        helloWorldLabel.translatesAutoresizingMaskIntoConstraints = false
        helloWorldLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        helloWorldLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    
    
    }
    
    private func setSignOutBtn(){
        signOutBtn.setTitle("Test sign out", for: .normal)
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signOutBtn.topAnchor.constraint(equalTo: self.helloWorldLabel.bottomAnchor).isActive = true
        signOutBtn.rx.tap.bind{
            GoogleSignInAuthenticator.sharedInstance.signOut()
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.changeRootViewController(LoginViewController())
            print("signed out!")
        }.disposed(by: disposeBag)
        
        
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
