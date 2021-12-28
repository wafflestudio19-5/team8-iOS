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
    let writePostBtn = UIButton(type:.custom)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        self.view.addSubview(helloWorldLabel)
        self.view.addSubview(signOutBtn)
        self.view.addSubview(writePostBtn)
        setHelloWorldLabel()
        setSignOutBtn()
        setWritePostBtn()
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
    
    private func setWritePostBtn(){
        let size:CGFloat = 60
        writePostBtn.translatesAutoresizingMaskIntoConstraints = false
        writePostBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        writePostBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        writePostBtn.heightAnchor.constraint(equalToConstant: size).isActive = true
        writePostBtn.widthAnchor.constraint(equalToConstant: size).isActive = true
        writePostBtn.backgroundColor = .orange
        writePostBtn.layer.cornerRadius = 0.5 * size;
        writePostBtn.clipsToBounds = true
        
        writePostBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        writePostBtn.setImage(UIImage(systemName: "plus"), for: .highlighted)
        writePostBtn.tintColor = .white
        
        writePostBtn.rx.tap.bind{
            self.navigationController?.pushViewController(WritePostViewController(), animated: true)
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
