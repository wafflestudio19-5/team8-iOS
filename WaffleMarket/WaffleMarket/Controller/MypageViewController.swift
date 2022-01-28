//
//  MypageViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/05.
//

import Foundation
import UIKit
import RxSwift
class MypageViewController: UIViewController {
    let tableView = UITableView()
    let viewModel = MypageViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        setTableView()
    }
    
    private func setTableView(){
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(MypageProfileCell.self, forCellReuseIdentifier: MypageProfileCell.identifier)
        tableView.register(MypageImageButtonCell.self, forCellReuseIdentifier: MypageImageButtonCell.identifier)

        var items = [MypageViewModelItem]()
        items.append(MypageViewModelImageButtonItem(image: UIImage(systemName: "pencil")!, title: "프로필 수정") {
            UserAPI.getProfile().subscribe { response in
                print(String(decoding: response.data, as: UTF8.self))
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(ProfileResponse.self, from: response.data) {
                    let username = decoded.username
                    let profileImage = decoded.profile_image
                    let profileImageView = UIImageView()
                    if let profileImage = profileImage {
                        CachedImageLoader().load(path: profileImage, putOn: profileImageView) { imageView, usedCache in
                            DispatchQueue.main.async {
                                self.present(SetProfileViewController(isSignUp: false, username: username, profileImage: profileImageView.image), animated: true)
                            }
                            
                        }
                    } else {
                        profileImageView.image = UIImage(named: "defaultProfileImage")
                        self.present(SetProfileViewController(isSignUp: false, username: username, profileImage: profileImageView.image), animated: true)
                    }
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

            
        })
        items.append(MypageViewModelImageButtonItem(image: UIImage(systemName: "slider.horizontal.3")!, title: "관심 카테고리 설정") {
            self.navigationController?.pushViewController(SetInterestViewController(), animated: true)
        })
        items.append(MypageViewModelImageButtonItem(image: UIImage(systemName: "escape")!, title: "로그아웃") {
            AccountManager.logout()
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.changeRootViewController(LoginViewController())
        })
        items.append(MypageViewModelImageButtonItem(image: UIImage(systemName: "person.badge.minus")!, title: "탈퇴") {
            let alert = UIAlertController(title: "경고", message: "정말 탈퇴할까요?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "취소", style: .cancel) { action in
                alert.dismiss(animated: true)
            }
            let yesAction = UIAlertAction(title: "탈퇴", style: .destructive) { action in
                WaffleAPI.leave().subscribe { response in
                    if response.statusCode/100 == 2 {
                        AccountManager.logout()
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.changeRootViewController(LoginViewController())
                        alert.dismiss(animated: true)
                    } else {
                        self.toast("탈퇴에 실패했어요")
                    }
                    
                } onFailure: { error in
                    self.toast("탈퇴에 실패했어요")
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)

                
                
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            
            self.present(alert, animated: true)
        })
        viewModel.setItems(items)
        tableView.reloadData()
    }
    
    
    
}
