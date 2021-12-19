//
//  SetProfileViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import ALCameraViewController
import Alamofire

class SetProfileViewController: UIViewController {
    
    var profileImage: UIImageView = UIImageView()
    var picSelectBtn: UIButton = UIButton()
    var nameField: UITextField = UITextField()
    var profileSaveBtn: UIButton = UIButton()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        self.view.addSubview(profileImage)
        setProfileImage()
        self.view.addSubview(picSelectBtn)
        setPicSelectBtn()
        self.view.addSubview(nameField)
        setNameField()
        self.view.addSubview(profileSaveBtn)
        setProfileSaveBtn()
    }
    
    private func setProfileImage(){
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    private func setPicSelectBtn(){
        picSelectBtn.translatesAutoresizingMaskIntoConstraints = false
        picSelectBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        picSelectBtn.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        picSelectBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        picSelectBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        picSelectBtn.setTitle("사진 선택", for: .normal)
        picSelectBtn.backgroundColor = .gray
        picSelectBtn.setTitleColor(.white, for: .normal)
        picSelectBtn.layer.cornerRadius = 10
        
        picSelectBtn.rx.tap.bind{
            let camera = CameraViewController {[weak self] image, asset in
                self?.profileImage.image = image
                let imageData = image?.jpegData(compressionQuality: 0.5)
                self!.sendImage(dataImage: imageData!)
                self?.dismiss(animated: true, completion: nil)
            }
            self.present(camera, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func sendImage(dataImage: Data?) {
        let headers: HTTPHeaders = [ "Content-type" : "multipart/form-data"]
        AF.upload(multipartFormData: { (multipartFormData) in
            if let data = dataImage {
                multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
            }
        }, to: "your_url", method: .post, headers: headers)
        
    }
    
    private func setNameField(){
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameField.topAnchor.constraint(equalTo: picSelectBtn.bottomAnchor, constant: 30).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        nameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        
        nameField.backgroundColor = .white
        nameField.placeholder = "닉네임을 입력하세요 (2글자 이상)"
    }
    
    private func setProfileSaveBtn(){
        profileSaveBtn.translatesAutoresizingMaskIntoConstraints = false
        profileSaveBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileSaveBtn.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30).isActive = true
        profileSaveBtn.heightAnchor.constraint(equalTo: nameField.heightAnchor).isActive = true
        profileSaveBtn.leadingAnchor.constraint(equalTo: nameField.leadingAnchor).isActive = true
        profileSaveBtn.trailingAnchor.constraint(equalTo: nameField.trailingAnchor).isActive = true
        
        profileSaveBtn.setTitle("프로필 저장", for: .normal)
        profileSaveBtn.backgroundColor = .orange
        profileSaveBtn.setTitleColor(.white, for: .normal)
        profileSaveBtn.layer.cornerRadius = 10
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
