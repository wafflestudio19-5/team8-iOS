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
    
    var waffleLogoLabel: UILabel = UILabel()
    var welcomeLabel: UILabel! = UILabel()
    var idField: UITextField = UITextField()
    var pwField: UITextField = UITextField()
    var loginBtn = UIButton(type: .system)
    var googleLoginBtn = UIButton(type: .system)
    var signUpBtn = UIButton(type: .system)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        loginBtn.rx.tap.bind{
            WaffleAPI.ping().subscribe { response in
                if let dict = try? response.mapJSON() as? [String:String]{
                    print(dict["ping"] ?? "")
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.changeRootViewController(MainTabBarController())
                    
                }
            } onFailure: { error in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let alertOKAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(alertOKAction)
                    self.present(alert, animated: true)
                }
            }.disposed(by: self.disposeBag)

        }.disposed(by: disposeBag)
        
        signUpBtn.rx.tap.bind{
            self.present(SignUpViewController(), animated:true, completion: nil)
        }
        
        self.view.addSubview(waffleLogoLabel)
        setWaffleLogoLabel()
        self.view.addSubview(welcomeLabel)
        setWelcomeLabel()
        self.view.addSubview(idField)
        setIdField()
        self.view.addSubview(pwField)
        setPwField()
        self.view.addSubview(loginBtn)
        setLoginBtn()
        self.view.addSubview(googleLoginBtn)
        setGoogleLoginBtn()
        self.view.addSubview(signUpBtn)
        setSignUpBtn()
        
        // Do any additional setup after loading the view.
    }
    
    private func setWaffleLogoLabel(){
        waffleLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        waffleLogoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        waffleLogoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        
        waffleLogoLabel.text = "🧇"
        waffleLogoLabel.font = .systemFont(ofSize: 100)
    }
    
    private func setWelcomeLabel(){
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: waffleLogoLabel.bottomAnchor, constant: 30).isActive = true
        
        welcomeLabel.text = "당신 근처의 와플마켓을 시작해보세요!"
    }
    
    private func setIdField(){
        idField.translatesAutoresizingMaskIntoConstraints = false
        idField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        idField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100).isActive = true
        idField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        idField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        idField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        idField.backgroundColor = .white
        idField.placeholder = "id"
    }
    
    private func setPwField(){
        pwField.translatesAutoresizingMaskIntoConstraints = false
        pwField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pwField.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 20).isActive = true
        pwField.leadingAnchor.constraint(equalTo: idField.leadingAnchor).isActive = true
        pwField.trailingAnchor.constraint(equalTo: idField.trailingAnchor).isActive = true
        pwField.heightAnchor.constraint(equalTo: idField.heightAnchor).isActive = true
        
        pwField.backgroundColor = .white
        pwField.placeholder = "pw"
    }
    
    private func setLoginBtn(){
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: pwField.bottomAnchor, constant: 50).isActive = true
        loginBtn.leadingAnchor.constraint(equalTo: pwField.leadingAnchor).isActive = true
        loginBtn.trailingAnchor.constraint(equalTo: pwField.trailingAnchor).isActive = true
        loginBtn.heightAnchor.constraint(equalTo: pwField.heightAnchor).isActive = true
        
        loginBtn.setTitle("로그인", for: .normal)
        loginBtn.backgroundColor = .orange
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 10
    }
    
    private func setGoogleLoginBtn(){
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        googleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleLoginBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20).isActive = true
        googleLoginBtn.leadingAnchor.constraint(equalTo: loginBtn.leadingAnchor).isActive = true
        googleLoginBtn.trailingAnchor.constraint(equalTo: loginBtn.trailingAnchor).isActive = true
        googleLoginBtn.heightAnchor.constraint(equalTo: loginBtn.heightAnchor).isActive = true
        
        googleLoginBtn.setTitle("Goggle로 로그인", for: .normal)
        googleLoginBtn.backgroundColor = .blue
        googleLoginBtn.setTitleColor(.white, for: .normal)
        googleLoginBtn.layer.cornerRadius = 10
    }
    
    private func setSignUpBtn(){
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: googleLoginBtn.bottomAnchor, constant: 20).isActive = true
        
        signUpBtn.setTitle("회원가입하기", for: .normal)
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
