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

class SignUpViewController: UIViewController {
    
    var idField: UITextField = UITextField()
    var idValidateBtn: UIButton = UIButton()
    var nameField: UITextField = UITextField()
    var pwField: UITextField = UITextField()
    var signUpBtn: UIButton = UIButton()
    var googleSignUpBtn: UIButton = UIButton()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        self.view.addSubview(idField)
        setPhoneNumField()
        self.view.addSubview(idValidateBtn)
        setIdValidateBtn()
        self.view.addSubview(pwField)
        setPwField()
        self.view.addSubview(signUpBtn)
        setSignUpBtn()
    }
    
    private func setPhoneNumField(){
        idField.translatesAutoresizingMaskIntoConstraints = false
        idField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        idField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        idField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        idField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        idField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        idField.backgroundColor = .white
        idField.placeholder = "핸드폰 번호를 입력하세요 (숫자만)"
    }
    
    private func setIdValidateBtn(){
        idValidateBtn.translatesAutoresizingMaskIntoConstraints = false
        idValidateBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        idValidateBtn.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 10).isActive = true
        idValidateBtn.leadingAnchor.constraint(equalTo: idField.leadingAnchor).isActive = true
        idValidateBtn.trailingAnchor.constraint(equalTo: idField.trailingAnchor).isActive = true
        idValidateBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        idValidateBtn.setTitle("인증하기", for: .normal)
        idValidateBtn.backgroundColor = .gray
        idValidateBtn.setTitleColor(.white, for: .normal)
        idValidateBtn.layer.cornerRadius = 10
    }
    
    private func setPwField(){
        pwField.translatesAutoresizingMaskIntoConstraints = false
        pwField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pwField.topAnchor.constraint(equalTo: idValidateBtn.bottomAnchor, constant: 20).isActive = true
        pwField.leadingAnchor.constraint(equalTo: idValidateBtn.leadingAnchor).isActive = true
        pwField.trailingAnchor.constraint(equalTo: idValidateBtn.trailingAnchor, constant: -80).isActive = true
        pwField.heightAnchor.constraint(equalTo: idField.heightAnchor).isActive = true
        
        pwField.backgroundColor = .white
        pwField.placeholder = "인증번호 입력"
    }
    
    private func setSignUpBtn(){
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: pwField.bottomAnchor, constant: 50).isActive = true
        signUpBtn.leadingAnchor.constraint(equalTo: pwField.leadingAnchor).isActive = true
        signUpBtn.trailingAnchor.constraint(equalTo: idValidateBtn.trailingAnchor).isActive = true
        signUpBtn.heightAnchor.constraint(equalTo: pwField.heightAnchor).isActive = true
        
        signUpBtn.setTitle("회원가입", for: .normal)
        signUpBtn.backgroundColor = .orange
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.layer.cornerRadius = 10
        
        signUpBtn.rx.tap.bind{
            self.present(SetProfileViewController(), animated:true, completion: nil)
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
