//
//  ProfileViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/16.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    let profileImageView = UIImageView()
    let profileLabel = UILabel()
    let mannerTempLabel = UILabel()
    let mannerBtn = UIButton()
    let reviewTableView = UITableView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "프로필"
        
        self.view.addSubview(profileImageView)
        setProfileImageView()
        self.view.addSubview(profileLabel)
        setProfileLabel()
        self.view.addSubview(mannerBtn)
        setMannerBtn()
        self.view.addSubview(mannerTempLabel)
        setMannerTempLabel()
        self.view.addSubview(reviewTableView)
        setReviewTableView()
    }
    
    private func setProfileImageView() {
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.image = UIImage(named: "defaultProfileImage")
        profileImageView.isUserInteractionEnabled = false
        
    }
    
    private func setProfileLabel() {
        
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.isUserInteractionEnabled = false
        profileLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        profileLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        profileLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        profileLabel.text = "Waffle Market"
        profileLabel.textColor = .black
        
    }
    
    private func setMannerBtn() {
        
        mannerBtn.translatesAutoresizingMaskIntoConstraints = false
        mannerBtn.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        mannerBtn.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        mannerBtn.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 150).isActive = true
        mannerBtn.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
        mannerBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        mannerBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mannerBtn.setTitle("매너평가 남기기", for: .normal)
        mannerBtn.titleLabel?.font = .systemFont(ofSize: 15)
        mannerBtn.backgroundColor = .orange
        mannerBtn.layer.cornerRadius = 10
        mannerBtn.titleLabel?.textColor = .white
        
        mannerBtn.rx.tap.bind{
            let alert = UIAlertController(title: "", message: "매너평가를 남기시겠어요?", preferredStyle: UIAlertController.Style.alert)
            
            let goodMannerAction = UIAlertAction(title: "매너 칭찬 남기기", style: UIAlertAction.Style.default) {(_) in
                let vc = ComplimentViewController()
                self.present(vc, animated: true)
            }
            
            let badMannerAction = UIAlertAction(title: "비매너 평가하기", style: UIAlertAction.Style.destructive) {(_) in
                let vc = ComplainViewController()
                self.present(vc, animated: true)
            }
            
            alert.addAction(goodMannerAction)
            alert.addAction(badMannerAction)
            self.present(alert, animated: false)
            
        }.disposed(by: disposeBag)
        
    }
    
    private func setMannerTempLabel() {
        
        mannerTempLabel.translatesAutoresizingMaskIntoConstraints = false
        mannerTempLabel.leadingAnchor.constraint(equalTo: mannerBtn.leadingAnchor).isActive = true
        mannerTempLabel.topAnchor.constraint(equalTo: mannerBtn.bottomAnchor, constant: 20).isActive = true
        mannerTempLabel.trailingAnchor.constraint(equalTo: profileLabel.trailingAnchor).isActive = true
        mannerTempLabel.bottomAnchor.constraint(equalTo: mannerBtn.bottomAnchor, constant: 50).isActive = true
        
        mannerTempLabel.text = "36.5°C"
        
    }
    
    private func setReviewTableView() {
        
        reviewTableView.translatesAutoresizingMaskIntoConstraints = false
        reviewTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        reviewTableView.topAnchor.constraint(equalTo: mannerTempLabel.bottomAnchor, constant: 30).isActive = true
        reviewTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        reviewTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func setData(username: String, profile_image: String, mannerTemp: Float){
        
        if profile_image == "default" {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        } else {
            CachedImageLoader().load(path: profile_image, putOn: profileImageView)
        }
        
        profileLabel.text = username
        mannerTempLabel.text = String(mannerTemp) + "°C ☺️"
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

