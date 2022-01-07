//
//  SetProfileViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import YPImagePicker

class SetProfileViewModel {
    let name = PublishRelay<String>()
    let saveBtnTouched = PublishRelay<Void>()
}
enum AccountType {
    case social
    case standalone
}

class SetProfileViewController: UIViewController {
    
    
    var profileImage: UIImage?
    var profileImageView: UIImageView = UIImageView()
    var picSelectBtn: UIButton = UIButton()
    var nameField: UITextField = UITextField()
    var profileSaveBtn: UIButton = UIButton()
    var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .orange
        view.progress = 0
        return view
    }()
    
    
    let disposeBag = DisposeBag()
    var accountType: AccountType = .standalone
    var userId: String?
    
    let viewModel = SetProfileViewModel()

    init(accountType: AccountType, userId: String){
        super.init(nibName: nil, bundle: nil)
        self.accountType = accountType
        self.userId = userId
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        self.view.addSubview(profileImageView)
        setProfileImage()
        self.view.addSubview(picSelectBtn)
        setPicSelectBtn()
        self.view.addSubview(nameField)
        setNameField()
        self.view.addSubview(profileSaveBtn)
        setProfileSaveBtn()
        self.view.addSubview(progressView)
        setProgressView()
    }
    
    private func setProfileImage(){
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage = UIImage(named: "defaultProfileImage")
        profileImageView.image = profileImage
        
    }
    
    private func setPicSelectBtn(){
        picSelectBtn.translatesAutoresizingMaskIntoConstraints = false
        picSelectBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        picSelectBtn.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        picSelectBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        picSelectBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        picSelectBtn.setTitle("사진 선택", for: .normal)
        picSelectBtn.backgroundColor = .gray
        picSelectBtn.setTitleColor(.white, for: .normal)
        picSelectBtn.layer.cornerRadius = 10
        picSelectBtn.titleLabel?.font = .systemFont(ofSize: 13)
        
        picSelectBtn.rx.tap.bind{
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = 1
            config.library.preSelectItemOnMultipleSelection = false
            config.library.mediaType = .photo
            config.library.isSquareByDefault = true
            config.onlySquareImagesFromCamera = true
            config.hidesCancelButton = false
            config.startOnScreen = .library
            let imagePicker = YPImagePicker(configuration: config)
            imagePicker.view.backgroundColor = .white
            imagePicker.didFinishPicking {[unowned imagePicker] items, cancelled in
                if let photo = items.singlePhoto {
                    self.profileImage = photo.image
                    self.profileImageView.image = self.profileImage
                }
                imagePicker.dismiss(animated: true)
            }
            self.present(imagePicker, animated: true)
        }.disposed(by: disposeBag)
    }
    
        
//        picSelectBtn.rx.tap.bind{
////            let camera = CameraViewController {[weak self] image, asset in
////                self?.profileImage.image = image
////                let imageData = image?.jpegData(compressionQuality: 0.5)
////                self!.sendImage(dataImage: imageData!)
////                self?.dismiss(animated: true, completion: nil)
////            }
////            self.present(camera, animated: true, completion: nil)
////        }.disposed(by: disposeBag)
    
//    private func sendImage(dataImage: Data?) {
////        let headers: HTTPHeaders = [ "Content-type" : "multipart/form-data"]
////        AF.upload(multipartFormData: { (multipartFormData) in
////            if let data = dataImage {
////                multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
////            }
////        }, to: "your_url", method: .post, headers: headers)
//
//    }
    
    private func setNameField(){
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameField.topAnchor.constraint(equalTo: picSelectBtn.bottomAnchor, constant: 30).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        nameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        
        nameField.backgroundColor = .white
        nameField.placeholder = "닉네임을 입력하세요"
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: disposeBag)
    }
    
    private func setProfileSaveBtn(){
        profileSaveBtn.translatesAutoresizingMaskIntoConstraints = false
        profileSaveBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileSaveBtn.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30).isActive = true
        profileSaveBtn.heightAnchor.constraint(equalTo: nameField.heightAnchor).isActive = true
        profileSaveBtn.leadingAnchor.constraint(equalTo: nameField.leadingAnchor).isActive = true
        profileSaveBtn.trailingAnchor.constraint(equalTo: nameField.trailingAnchor).isActive = true
        
        profileSaveBtn.setTitle("가입 완료", for: .normal)
        profileSaveBtn.backgroundColor = .orange
        profileSaveBtn.setTitleColor(.white, for: .normal)
        profileSaveBtn.layer.cornerRadius = 10
        profileSaveBtn.titleLabel?.font = .systemFont(ofSize: 14)
        
        profileSaveBtn.rx.tap.bind(to: viewModel.saveBtnTouched).disposed(by: disposeBag)
        
        profileSaveBtn.rx.tap.bind{
            guard let username = self.nameField.text else { return }
            guard let profileImage = self.profileImage else {
                self.toast("프로필 이미지를 선택하세요")
                return
            }
            // MARK: upload profile image
            let profile = Profile(phoneNumber: self.userId!, userName: username, profileImage: profileImage)
            WaffleAPI.signup(profile: profile).subscribe { response in
                let decoder = JSONDecoder()
                if (response.statusCode / 100) == 2 {
                    if let decoded = try? decoder.decode(LoginResponse.self, from: response.data) {
                        AccountManager.login(decoded)
                        UserAPI.setProfile(profile: profile).subscribe { progressResponse in
                            print(progressResponse.progress)
                            self.progressView.progress = Float(progressResponse.progress)
                            if progressResponse.completed {
                                print(String(decoding: progressResponse.response!.data, as: UTF8.self))
                                if (progressResponse.response!.statusCode/100) == 2 {
                                    if decoded.location_exists {
                                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                                        sceneDelegate?.changeRootViewController(MainTabBarController())
                                    } else {
                                        self.navigationController?.pushViewController(SetLocationViewController(), animated:true)
                                    }
                                    return
                                }
                                self.toast("오류가 발생했어요")
                            }
                        } onError: { error in
                            self.toast("오류가 발생했어요")
                        }.disposed(by: self.disposeBag)

                        
                        return
                    }
                }
                if let decoded = try? decoder.decode(NonFieldErrorsResponse.self, from: response.data){
                    if decoded.non_field_errors.count >= 1 {
                        self.toast(decoded.non_field_errors[0])
                    }
                    return
                }
                self.toast("오류가 발생했어요")
                
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

            
        }.disposed(by: disposeBag)
    }
    private func setProgressView(){
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: profileSaveBtn.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: profileSaveBtn.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: profileSaveBtn.bottomAnchor, constant: 30).isActive = true
        
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

