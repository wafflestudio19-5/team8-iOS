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

class LoginViewModel {
    
    let id = PublishRelay<String>()
    let pw = PublishRelay<String>()
    let loginBtnTouched = PublishRelay<Void>()
    
}

class LoginViewController: UIViewController {

    var googleLoginBtn = GIDSignInButton()

    
    var waffleLogoLabel: UILabel = UILabel()
    var welcomeLabel: UILabel! = UILabel()
    var idField: UITextField = UITextField()
    let idText = BehaviorSubject(value: "")
    let isIdValid = BehaviorSubject(value: false)
    var idValidateBtn: UIButton = UIButton()
    var pwField: UITextField = UITextField()
    let pwText = BehaviorSubject(value: "")
    let isPwValid = BehaviorSubject(value: false)
    var loginBtn = UIButton(type: .system)
    var signUpBtn = UIButton(type: .system)

    let disposeBag = DisposeBag()
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        


        
        
        self.view.addSubview(waffleLogoLabel)
        setWaffleLogoLabel()
        self.view.addSubview(welcomeLabel)
        setWelcomeLabel()
        self.view.addSubview(idField)
        setIdField()
        idField.becomeFirstResponder()
        self.view.addSubview(idValidateBtn)
        setIdValidateBtn()
        self.view.addSubview(pwField)
        setPwField()
        self.view.addSubview(loginBtn)
        setLoginBtn()
        self.view.addSubview(googleLoginBtn)
        setGoogleLoginBtn()
        self.view.addSubview(signUpBtn)
        setSignUpBtn()
        
        Observable.combineLatest(isIdValid, isPwValid, resultSelector: {$0 && $1})
            .subscribe { value in
                guard let element = value.element else { return }
                if element {
                    self.loginBtn.alpha=1
                } else {
                    self.loginBtn.alpha=0.5
                }
                self.loginBtn.isEnabled = element
            }.disposed(by: disposeBag)
        
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
        idField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100).isActive = true
        idField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        idField.backgroundColor = .white
        idField.placeholder = "휴대폰 번호를 입력하세요"
        idField.autocapitalizationType = .none
        idField.autocorrectionType = .no
        idField.rx.text.orEmpty.bind(to: idText).disposed(by: disposeBag)
        idField.rx.text.orEmpty.bind(to: loginViewModel.id).disposed(by: disposeBag)
        idText.map(validateID(_:)).bind(to: isIdValid).disposed(by: disposeBag)
    }
    
    private func setIdValidateBtn(){
        idValidateBtn.translatesAutoresizingMaskIntoConstraints = false
        idValidateBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        idValidateBtn.topAnchor.constraint(equalTo: idField.topAnchor, constant: 10).isActive = true
        idValidateBtn.leadingAnchor.constraint(equalTo: idField.leadingAnchor, constant: 230).isActive = true
        idValidateBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        idValidateBtn.heightAnchor.constraint(equalTo: idField.heightAnchor, constant: -20).isActive = true
        
        idValidateBtn.setTitle("인증하기", for: .normal)
        idValidateBtn.backgroundColor = .gray
        idValidateBtn.setTitleColor(.white, for: .normal)
        idValidateBtn.layer.cornerRadius = 10
        idValidateBtn.titleLabel?.font = .systemFont(ofSize: 13)
    }
    
    private func setPwField(){
        pwField.translatesAutoresizingMaskIntoConstraints = false
        pwField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pwField.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 20).isActive = true
        pwField.leadingAnchor.constraint(equalTo: idField.leadingAnchor).isActive = true
        pwField.trailingAnchor.constraint(equalTo: idValidateBtn.trailingAnchor).isActive = true
        pwField.heightAnchor.constraint(equalTo: idField.heightAnchor).isActive = true
        
        pwField.backgroundColor = .white
        pwField.placeholder = "인증번호를 입력하세요"
        pwField.isSecureTextEntry = true
        pwField.autocapitalizationType = .none
        pwField.autocorrectionType = .no
        pwField.rx.text.orEmpty.bind(to: pwText).disposed(by: disposeBag)
        pwField.rx.text.orEmpty.bind(to: loginViewModel.pw).disposed(by: disposeBag)
        pwText.map(validatePassword(_:)).bind(to: isPwValid).disposed(by: disposeBag)
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
        
        loginBtn.rx.tap.bind(to: loginViewModel.loginBtnTouched).disposed(by: disposeBag)
    }
    
    private func setGoogleLoginBtn(){
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        googleLoginBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleLoginBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20).isActive = true
        googleLoginBtn.leadingAnchor.constraint(equalTo: loginBtn.leadingAnchor).isActive = true
        googleLoginBtn.trailingAnchor.constraint(equalTo: loginBtn.trailingAnchor).isActive = true
        googleLoginBtn.heightAnchor.constraint(equalTo: loginBtn.heightAnchor).isActive = true
      
        googleLoginBtn.rx.controlEvent(.touchUpInside).bind{
            GoogleSignInAuthenticator.sharedInstance.signIn(presenting: self, disposeBag: self.disposeBag) {
                print("success")
            }
        }.disposed(by: disposeBag)
    }
    
    private func setSignUpBtn(){
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: googleLoginBtn.bottomAnchor, constant: 20).isActive = true
        
        signUpBtn.setTitle("회원가입하기", for: .normal)
        
        signUpBtn.rx.tap.bind{
            
            self.present(UINavigationController(rootViewController: SignUpViewController()), animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func validateID(_ id: String)->Bool{
        return !id.isEmpty
    }
    
    private func validatePassword(_ pw: String)->Bool{
        return !pw.isEmpty
    }
    
    private func moveToHome() {
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootViewController(MainTabBarController())
    
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
