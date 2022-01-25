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
    
    let topView = UIView()
    let tableView = UITableView()
    
    let profileImageView = UIImageView()
    let usernameLabel = UILabel()
    let showProfileBtn = UIButton()
    let sellListBtn = UIButton()
    let buyListBtn = UIButton()
    let likeListBtn = UIButton()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .large)
    
    let viewModel = MypageViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(topView)
        setTopView()
        self.view.addSubview(tableView)
        setTableView()
    }
    
    private func setTopView() {
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        
        topView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: topView.topAnchor, constant: 60).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 80).isActive = true
        profileImageView.image = UIImage(named: "defaultProfileImage")
        profileImageView.isUserInteractionEnabled = false
        
        topView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 15).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        usernameLabel.text = "WaffleMarket"
        usernameLabel.textColor = .black
        
        topView.addSubview(showProfileBtn)
        showProfileBtn.translatesAutoresizingMaskIntoConstraints = false
        showProfileBtn.leadingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -50).isActive = true
        showProfileBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20).isActive = true
        showProfileBtn.topAnchor.constraint(equalTo: usernameLabel.topAnchor).isActive = true
        showProfileBtn.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        showProfileBtn.setImage(UIImage(systemName: "arrow.forward"), for: .normal)

//        showProfileBtn.rx.tap.bind{
//            let vc = ProfileViewController()
//            // TODO: article에서 id 받아와서 프로필 찾고 보내기
//            self.present(vc, animated: true)
//        }.disposed(by: disposeBag)
        
        topView.addSubview(sellListBtn)
        sellListBtn.translatesAutoresizingMaskIntoConstraints = false
        sellListBtn.leadingAnchor.constraint(equalTo: topView.centerXAnchor, constant: -110).isActive = true
        sellListBtn.trailingAnchor.constraint(equalTo: topView.centerXAnchor, constant: -60).isActive = true
        sellListBtn.topAnchor.constraint(equalTo: showProfileBtn.bottomAnchor, constant: 20).isActive = true
        sellListBtn.setImage(UIImage(systemName: "line.horizontal.3.circle.fill", withConfiguration: largeConfig), for: .normal)
        
        sellListBtn.rx.tap.bind {
            self.sendList(listName: "sell")
        }.disposed(by: disposeBag)
        
        topView.addSubview(buyListBtn)
        buyListBtn.translatesAutoresizingMaskIntoConstraints = false
        buyListBtn.leadingAnchor.constraint(equalTo: sellListBtn.trailingAnchor, constant: 20).isActive = true
        buyListBtn.trailingAnchor.constraint(equalTo: sellListBtn.trailingAnchor, constant: 80).isActive = true
        buyListBtn.topAnchor.constraint(equalTo: sellListBtn.topAnchor).isActive = true
        buyListBtn.setImage(UIImage(systemName: "bag.circle.fill", withConfiguration: largeConfig), for: .normal)
        
        buyListBtn.rx.tap.bind {
            self.sendList(listName: "buy")
        }.disposed(by: disposeBag)
        
        topView.addSubview(likeListBtn)
        likeListBtn.translatesAutoresizingMaskIntoConstraints = false
        likeListBtn.leadingAnchor.constraint(equalTo: buyListBtn.trailingAnchor, constant: 20).isActive = true
        likeListBtn.trailingAnchor.constraint(equalTo: buyListBtn.trailingAnchor, constant: 80).isActive = true
        likeListBtn.topAnchor.constraint(equalTo: buyListBtn.topAnchor).isActive = true
        likeListBtn.setImage(UIImage(systemName: "heart.circle.fill", withConfiguration: largeConfig), for: .normal)
        
        likeListBtn.rx.tap.bind {
            self.sendList(listName: "like")
        }.disposed(by: disposeBag)
        
        
    }
    
    private func sendList(listName: String) {
        print("sendList")
        let controller = ArticleListViewController()

        controller.listName = listName
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setTableView(){
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
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
                    CachedImageLoader().load(path: profileImage, putOn: profileImageView) { imageView, usedCache in
                        DispatchQueue.main.async {
                            self.present(SetProfileViewController(isSignUp: false, username: username, profileImage: profileImageView.image), animated: true)
                        }
                        
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
