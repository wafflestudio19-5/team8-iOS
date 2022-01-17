//
//  SignUpViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class SignUpViewModel {
    
    let id = PublishRelay<String>()
    let pw = PublishRelay<String>()
    let signUpBtnTouched = PublishRelay<Void>()
    
}

class SignUpViewController: UIViewController {
    
    var idField: UITextField = UITextField()
    let idText = BehaviorSubject(value: "")
    let isIdValid = BehaviorSubject(value: false)
    var idValidateBtn: UIButton = UIButton()
    var pwField: UITextField = UITextField()
    let pwText = BehaviorSubject(value: "")
    let isPwValid = BehaviorSubject(value: false)
    var signUpBtn: UIButton = UIButton()
    
    let disposeBag = DisposeBag()
    let viewModel = SignUpViewModel()
    var authPhoneNumber = ""
    var originalViewY: CGFloat = 0
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("kwillshow")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
      
      // move the root view up by the distance of keyboard height
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        let viewOffset = screenHeight - self.view.frame.size.height
        let delta = ((self.signUpBtn.frame.origin.y + self.signUpBtn.frame.size.height + 10 + viewOffset) - keyboardSize.origin.y)
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
        // Do any additional setup after loading the view.
        originalViewY = self.view.frame.origin.y
        self.view.addSubview(idField)
        setIdField()
        idField.becomeFirstResponder()
        self.view.addSubview(idValidateBtn)
        setIdValidateBtn()
        self.view.addSubview(pwField)
        setPwField()
        self.view.addSubview(signUpBtn)
        setSignUpBtn()
        
        Observable.combineLatest(isIdValid, isPwValid, resultSelector: {$0 && $1})
            .subscribe { value in
                guard let element = value.element else { return }
                if element {
                    self.signUpBtn.alpha=1
                } else {
                    self.signUpBtn.alpha=0.5
                }
                self.signUpBtn.isEnabled = element
            }.disposed(by: disposeBag)
    }
    
    private func setIdField(){
        idField.translatesAutoresizingMaskIntoConstraints = false
        idField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        idField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        idField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        idField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100).isActive = true
        idField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        idField.backgroundColor = .white
        idField.placeholder = "핸드폰 번호를 입력하세요"
        idField.autocapitalizationType = .none
        idField.autocorrectionType = .no
        idField.rx.text.orEmpty.bind(to: idText).disposed(by: disposeBag)
        idField.rx.text.orEmpty.bind(to: viewModel.id).disposed(by: disposeBag)
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
        
        idValidateBtn.rx.tap.bind{ // MARK: apply MVVM
            guard let phoneNumber = self.idField.text else { return }
            self.authPhoneNumber = phoneNumber
            WaffleAPI.startAuth(phoneNumber: phoneNumber).subscribe { response in
                let decoder = JSONDecoder()
                if (response.statusCode / 100) == 4 {
                    self.toast("전화번호가 올바르지 않아요", y: self.signUpBtn.frame.origin.y)
                    return
                }
                if let decoded = try? decoder.decode(StartAuthResponse.self, from: response.data) {
                    if let authnumber = decoded.auth_number {
                        self.toast("테스트용 인증번호: \(authnumber)", y: self.signUpBtn.frame.origin.y)
                        
                    } else {
                        self.toast("인증번호가 전송되었어요", y: self.signUpBtn.frame.origin.y)
                    }
                    
                    print(decoded.auth_number ?? "no auth_number")
                } else {
                    self.toast("오류가 발생했어요", y: self.signUpBtn.frame.origin.y)
                    print("failed to decode StartAuthResponse")
                }
            } onFailure: { error in
                
            } onDisposed: {
                
                
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
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
        pwField.autocapitalizationType = .none
        pwField.autocorrectionType = .no
        pwField.rx.text.orEmpty.bind(to: pwText).disposed(by: disposeBag)
        pwField.rx.text.orEmpty.bind(to: viewModel.pw).disposed(by: disposeBag)
        pwText.map(validatePassword(_:)).bind(to: isPwValid).disposed(by: disposeBag)
    }
    
    private func setSignUpBtn(){
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: pwField.bottomAnchor, constant: 50).isActive = true
        signUpBtn.leadingAnchor.constraint(equalTo: pwField.leadingAnchor).isActive = true
        signUpBtn.trailingAnchor.constraint(equalTo: idValidateBtn.trailingAnchor).isActive = true
        signUpBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signUpBtn.setTitle("회원가입", for: .normal)
        signUpBtn.backgroundColor = .orange
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.layer.cornerRadius = 10
        signUpBtn.titleLabel?.font = .systemFont(ofSize: 14)
        
        signUpBtn.rx.tap.bind(to: viewModel.signUpBtnTouched).disposed(by: disposeBag)
        
        signUpBtn.rx.tap.bind{ // MARK: apply MVVM
            guard let authNumber = self.pwField.text else { return }
            WaffleAPI.completeAuth(phoneNumber: self.authPhoneNumber, authNumber: authNumber).subscribe { response in
                if (response.statusCode / 100) == 4 {
                    self.toast("인증번호가 올바르지 않아요", y: self.signUpBtn.frame.origin.y)
                    return
                }
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(CompleteAuthResponse.self, from:response.data) {
                        if decoded.authenticated {
                            let vc = SetProfileViewController(userId: self.authPhoneNumber)
                            self.navigationController?.pushViewController(vc, animated:true)
                        } else {
                            
                        }
                    } else if let decoded = try? decoder.decode(LoginResponse.self, from: response.data) {
                        AccountManager.login(decoded)
                    
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.changeRootViewController(MainTabBarController())
                    
                        self.navigationController?.pushViewController(SetLocationViewController(), animated:true)
                        
                    }
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
    }
    
    private func validateID(_ id: String)->Bool{
        return !id.isEmpty
    }
    
    private func validatePassword(_ pw: String)->Bool{
        return !pw.isEmpty
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
