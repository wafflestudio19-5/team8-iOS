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
    
    let scrollView = UIScrollView()
    let profileImageView = UIImageView()
    let profileLabel = UILabel()
    let mannerTempLabel = UILabel()
    let mannerBtn = UIButton()
    let showReviewBtn = UIButton()
    let reviewView = UIView()
    let mannerReviewLabel = UILabel()
    var time = 0
    var kind = 0
    var fast = 0
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "프로필"
        
        self.view.addSubview(scrollView)
        setScrollView()
    }
    
    private func setScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(profileImageView)
        setProfileImageView()
        scrollView.addSubview(profileLabel)
        setProfileLabel()
        scrollView.addSubview(mannerBtn)
        setMannerBtn()
        scrollView.addSubview(showReviewBtn)
        setShowReviewBtn()
        scrollView.addSubview(mannerTempLabel)
        setMannerTempLabel()
        scrollView.addSubview(reviewView)
        setReviewView()
    }
    
    private func setProfileImageView() {
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 100).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.image = UIImage(named: "defaultProfileImage")
        profileImageView.isUserInteractionEnabled = false
        
    }
    
    private func setProfileLabel() {
        
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.isUserInteractionEnabled = false
        profileLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        profileLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
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
    
    private func setShowReviewBtn() {
        
        showReviewBtn.translatesAutoresizingMaskIntoConstraints = false
        showReviewBtn.leadingAnchor.constraint(equalTo: mannerBtn.leadingAnchor).isActive = true
        showReviewBtn.topAnchor.constraint(equalTo: mannerBtn.bottomAnchor, constant: 10).isActive = true
        showReviewBtn.trailingAnchor.constraint(equalTo: mannerBtn.trailingAnchor).isActive = true
        showReviewBtn.bottomAnchor.constraint(equalTo: mannerBtn.bottomAnchor, constant: 40).isActive = true
        showReviewBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        showReviewBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        showReviewBtn.setTitle("거래후기 조회하기", for: .normal)
        showReviewBtn.titleLabel?.font = .systemFont(ofSize: 15)
        showReviewBtn.backgroundColor = .orange
        showReviewBtn.layer.cornerRadius = 10
        showReviewBtn.titleLabel?.textColor = .white
        
        showReviewBtn.rx.tap.bind {
            let vc = ReviewViewController()
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setMannerTempLabel() {
        
        mannerTempLabel.translatesAutoresizingMaskIntoConstraints = false
        mannerTempLabel.leadingAnchor.constraint(equalTo: showReviewBtn.leadingAnchor).isActive = true
        mannerTempLabel.topAnchor.constraint(equalTo: showReviewBtn.bottomAnchor, constant: 20).isActive = true
        mannerTempLabel.trailingAnchor.constraint(equalTo: showReviewBtn.trailingAnchor).isActive = true
        mannerTempLabel.bottomAnchor.constraint(equalTo: showReviewBtn.bottomAnchor, constant: 50).isActive = true
        
        mannerTempLabel.text = "36.5°C"
        
    }
    
    private func setReviewView() {
        
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        reviewView.topAnchor.constraint(equalTo: mannerTempLabel.bottomAnchor, constant: 30).isActive = true
        reviewView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        reviewView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        reviewView.addSubview(mannerReviewLabel)
        mannerReviewLabel.translatesAutoresizingMaskIntoConstraints = false
        mannerReviewLabel.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor, constant: 20).isActive = true
        mannerReviewLabel.topAnchor.constraint(equalTo: reviewView.topAnchor).isActive = true
        mannerReviewLabel.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor).isActive = true
        
        mannerReviewLabel.numberOfLines = 5
        mannerReviewLabel.text = "받은 매너 평가\n\n👥 " + String(kind) + "  친절하고 매너가 좋아요\n👥 " + String(fast) + " 응답이 빨라요\n👥 " + String(time) + " 시간 약속을 잘 지켜요"
        
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

