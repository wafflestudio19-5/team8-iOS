//
//  SignUpViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/08.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var idField: UITextField = UITextField()
    var nameField: UITextField = UITextField()
    var pwField: UITextField = UITextField()
    var signUpBtn: UIButton = UIButton()
    var googleSignUpBtn: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        self.view.addSubview(idField)
        setPhoneNumField()
        self.view.addSubview(nameField)
        setNameField()
        self.view.addSubview(pwField)
        setPwField()
        self.view.addSubview(signUpBtn)
        setSignUpBtn()
        self.view.addSubview(googleSignUpBtn)
        setGoogleSignUpBtn()
        
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
    
    private func setNameField(){
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameField.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 20).isActive = true
        nameField.leadingAnchor.constraint(equalTo: idField.leadingAnchor).isActive = true
        nameField.trailingAnchor.constraint(equalTo: idField.trailingAnchor).isActive = true
        nameField.heightAnchor.constraint(equalTo: idField.heightAnchor).isActive = true
        
        nameField.backgroundColor = .white
        nameField.placeholder = "닉네임을 설정하세요(2글자 이상)"
    }
    
    private func setPwField(){
        pwField.translatesAutoresizingMaskIntoConstraints = false
        pwField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pwField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20).isActive = true
        pwField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor).isActive = true
        pwField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor).isActive = true
        pwField.heightAnchor.constraint(equalTo: nameField.heightAnchor).isActive = true
        
        pwField.backgroundColor = .white
        pwField.placeholder = "패스워드를 설정하세요 (영문+숫자 6글자 이상)"
    }
    
    private func setSignUpBtn(){
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpBtn.topAnchor.constraint(equalTo: pwField.bottomAnchor, constant: 50).isActive = true
        signUpBtn.leadingAnchor.constraint(equalTo: pwField.leadingAnchor).isActive = true
        signUpBtn.trailingAnchor.constraint(equalTo: pwField.trailingAnchor).isActive = true
        signUpBtn.heightAnchor.constraint(equalTo: pwField.heightAnchor).isActive = true
        
        signUpBtn.setTitle("회원가입", for: .normal)
        signUpBtn.backgroundColor = .orange
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.layer.cornerRadius = 10
    }
    
    private func setGoogleSignUpBtn(){
        googleSignUpBtn.translatesAutoresizingMaskIntoConstraints = false
        googleSignUpBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSignUpBtn.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 20).isActive = true
        googleSignUpBtn.leadingAnchor.constraint(equalTo: signUpBtn.leadingAnchor).isActive = true
        googleSignUpBtn.trailingAnchor.constraint(equalTo: signUpBtn.trailingAnchor).isActive = true
        googleSignUpBtn.heightAnchor.constraint(equalTo: signUpBtn.heightAnchor).isActive = true
        
        googleSignUpBtn.setTitle("Goggle로 회원가입", for: .normal)
        googleSignUpBtn.backgroundColor = .blue
        googleSignUpBtn.setTitleColor(.white, for: .normal)
        googleSignUpBtn.layer.cornerRadius = 10
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
