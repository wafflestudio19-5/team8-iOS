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
    var authPhoneNumber = ""
    var originalViewY: CGFloat = 0
    @objc func keyboardWillShow(notification: NSNotification) {
        print("kwillshow")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
      
      // move the root view up by the distance of keyboard height
        let delta = ((self.loginBtn.frame.origin.y + self.loginBtn.frame.size.height + 10) - keyboardSize.origin.y)
        if delta > 0 {
            self.view.frame.origin.y = originalViewY - delta
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("kwillhide")
      
      // move the root view up by the distance of keyboard height
        
        self.view.frame.origin.y = originalViewY
    }
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        originalViewY = self.view.frame.origin.y
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

       //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        if AccountManager.tryAutologin() {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.changeRootViewController(MainTabBarController())
            return
        }
        
        
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
        waffleLogoLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        waffleLogoLabel.topAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        waffleLogoLabel.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        waffleLogoLabel.text = "🧇"
        waffleLogoLabel.font = .systemFont(ofSize: 100)
    }
    
    private func setWelcomeLabel(){
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: waffleLogoLabel.bottomAnchor, constant: 30).isActive = true
        
        welcomeLabel.text = "당신 근처의 와플마켓을 시작해보세요!"
    }
    
    private func setIdField(){
        idField.translatesAutoresizingMaskIntoConstraints = false
        
        idField.topAnchor.constraint(lessThanOrEqualTo: welcomeLabel.bottomAnchor, constant: 100).isActive = true
        idField.topAnchor.constraint(greaterThanOrEqualTo: welcomeLabel.bottomAnchor, constant: 10).isActive = true
        idField.leadingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        idField.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        
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
        
        idValidateBtn.topAnchor.constraint(equalTo: idField.topAnchor, constant: 10).isActive = true
        idValidateBtn.leadingAnchor.constraint(greaterThanOrEqualTo: idField.trailingAnchor).isActive = true
        idValidateBtn.trailingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        idValidateBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        idValidateBtn.heightAnchor.constraint(equalTo: idField.heightAnchor, constant: -20).isActive = true
        
        idValidateBtn.setTitle("인증하기", for: .normal)
        idValidateBtn.backgroundColor = .gray
        idValidateBtn.setTitleColor(.white, for: .normal)
        idValidateBtn.layer.cornerRadius = 10
        idValidateBtn.titleLabel?.font = .systemFont(ofSize: 13)
        
        idValidateBtn.rx.tap.bind{ // MARK: apply MVVM
            guard let phoneNumber = self.idField.text else { return }
            self.authPhoneNumber = phoneNumber
            WaffleAPI.startAuth(phoneNumber: phoneNumber).subscribe { response in
                let decoder = JSONDecoder()
                if (response.statusCode / 100) == 4 {
                    self.toast("전화번호가 올바르지 않아요", y: self.loginBtn.frame.origin.y)
                    return
                }
                if let decoded = try? decoder.decode(StartAuthResponse.self, from: response.data) {
                    self.pwField.becomeFirstResponder()
                    if let authnumber = decoded.auth_number {
                        self.toast("테스트용 인증번호: \(authnumber)", y: self.loginBtn.frame.origin.y)
                        
                    } else {
                        self.toast("인증번호가 전송되었어요", y: self.loginBtn.frame.origin.y)
                    }
                    
                    print(decoded.auth_number ?? "no auth_number")
                } else {
                    self.toast("오류가 발생했어요", y: self.loginBtn.frame.origin.y)
                    print("failed to decode StartAuthResponse")
                }
            } onFailure: { error in
                
            } onDisposed: {
                
                
            }.disposed(by: self.disposeBag)

        }.disposed(by: disposeBag)
    }
    
    private func setPwField(){
        pwField.translatesAutoresizingMaskIntoConstraints = false
        
        pwField.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 20).isActive = true
        pwField.leadingAnchor.constraint(equalTo: idField.leadingAnchor).isActive = true
        pwField.trailingAnchor.constraint(equalTo: idValidateBtn.trailingAnchor).isActive = true
        pwField.heightAnchor.constraint(equalTo: idField.heightAnchor).isActive = true
        
        pwField.backgroundColor = .white
        pwField.placeholder = "인증번호를 입력하세요"
        pwField.autocapitalizationType = .none
        pwField.autocorrectionType = .no
        pwField.rx.text.orEmpty.bind(to: pwText).disposed(by: disposeBag)
        pwField.rx.text.orEmpty.bind(to: loginViewModel.pw).disposed(by: disposeBag)
        pwText.map(validatePassword(_:)).bind(to: isPwValid).disposed(by: disposeBag)
    }
    
    private func setLoginBtn(){

        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        
        loginBtn.topAnchor.constraint(lessThanOrEqualTo: pwField.bottomAnchor, constant: 50).isActive = true
        loginBtn.leadingAnchor.constraint(equalTo: pwField.leadingAnchor).isActive = true
        loginBtn.trailingAnchor.constraint(equalTo: pwField.trailingAnchor).isActive = true
        loginBtn.heightAnchor.constraint(equalTo: pwField.heightAnchor).isActive = true
        
        loginBtn.setTitle("로그인", for: .normal)
        loginBtn.backgroundColor = .orange
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 10
        
        // loginBtn.rx.tap.bind(to: loginViewModel.loginBtnTouched).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind{
            guard let authNumber = self.pwField.text else { return }
            WaffleAPI.completeAuth(phoneNumber: self.authPhoneNumber, authNumber: authNumber).subscribe { response in
                if (response.statusCode / 100) == 4 {
                    self.toast("인증번호가 올바르지 않아요")
                    return
                }
                if (response.statusCode / 100) == 2{
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(LoginResponse.self, from:response.data) {
                        AccountManager.login(decoded, autologin: true)
                        if decoded.location_exists {
                            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                            sceneDelegate?.changeRootViewController(MainTabBarController())
                        } else {
                            self.present(SetLocationViewController(), animated:true)
                        }
                    } else {
                        let alert = UIAlertController(title: "알림", message: "가입되지 않은 전화번호입니다.", preferredStyle: .alert)
                        let close = UIAlertAction(title: "닫기", style: .cancel) { action in
                            alert.dismiss(animated: true)
                        }
                        let signup = UIAlertAction(title: "이 번호로 가입", style: .default) { action in
                            
                            alert.dismiss(animated: true)
                            let vc = UINavigationController(rootViewController: SetProfileViewController(accountType: .standalone, userId: self.authPhoneNumber))
                            self.present(vc, animated: true)
                        }
                        alert.addAction(close)
                        alert.addAction(signup)
                        self.present(alert, animated: true)
                    }
                } else {
                    self.toast("오류가 발생했어요", y: self.loginBtn.frame.origin.y)
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

        }.disposed(by: disposeBag)
    }
    
    private func setGoogleLoginBtn(){
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        
        googleLoginBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20).isActive = true
        googleLoginBtn.leadingAnchor.constraint(equalTo: loginBtn.leadingAnchor).isActive = true
        googleLoginBtn.trailingAnchor.constraint(equalTo: loginBtn.trailingAnchor).isActive = true
        googleLoginBtn.heightAnchor.constraint(equalTo: loginBtn.heightAnchor).isActive = true
      
        googleLoginBtn.rx.controlEvent(.touchUpInside).bind{
            print("gcli")
            GoogleSignInAuthenticator.sharedInstance.signIn(presenting: self, disposeBag: self.disposeBag) {
                print("success")
            }
        }.disposed(by: disposeBag)
    }
    
    private func setSignUpBtn(){
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: googleLoginBtn.bottomAnchor, constant: 20).isActive = true
        signUpBtn.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        signUpBtn.setTitle("회원가입하기", for: .normal)
        
        signUpBtn.rx.tap.bind{
            print("click")
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
