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

class LoginViewController: UIViewController {
    var loginBtn = UIButton(type: .system)
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loginBtn.setTitle("Test Login", for: .normal)
        
        loginBtn.rx.tap.bind{
            WaffleAPI.ping().subscribe { response, json in
                if let dict = json as? [String:String]{
                    print(dict["ping"] ?? "")
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = MainTabBarController()
                    
                }
            } onError: { error in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let alertOKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(alertOKAction)
                    self.present(alert, animated: true)
                }
            }.disposed(by: self.disposeBag)

        }
        self.view.addSubview(loginBtn)
        setLoginBtn()
        
        // Do any additional setup after loading the view.
    }
    private func setLoginBtn(){
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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
