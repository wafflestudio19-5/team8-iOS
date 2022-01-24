//
//  ArticleViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/07.
//

import UIKit
import RxSwift

class ArticleViewController: UIViewController {

    let scrollView = UIScrollView()
    let bottomView = UIView()
    let profileView = UIView()
    
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let priceLabel = UILabel()
    let contentText = UILabel()
    let productImage = UIImageView()
    let commentBtn = UIButton()
    let chatBtn = UIButton()
    let likeBtn = UIButton(type: .custom)
    let profileImageView = UIImageView()
    let profileBtn = UIButton()
    let mannerTempLabel = UILabel()
    
    let disposeBag = DisposeBag()
    var articleId = 0
    var articleSelected: Article?
    var isLiked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        setScrollView()
        view.addSubview(bottomView)
        setBottomView()
        // Do any additional setup after loading the view.
    }
    
    private func setScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        
        scrollView.addSubview(productImage)
        setProductImage()
        scrollView.addSubview(profileView)
        setProfileView()
        scrollView.addSubview(titleLabel)
        setTitleLabel()
        scrollView.addSubview(categoryLabel)
        setCategoryLabel()
        scrollView.addSubview(contentText)
        setContentLabel()
        
    }
    
    private func setBottomView() {
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomView.addSubview(likeBtn)
        setLikeBtn()
        bottomView.addSubview(priceLabel)
        setPriceLabel()
        bottomView.addSubview(commentBtn)
        setCommentBtn()
        //bottomView.addSubview(chatBtn)
       // setChatBtn()
    
    }
    
    private func getArticleImage(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        guard let data = try? Data(contentsOf: url!) else {return UIImage(named: "noImageAvailable") ?? UIImage(named: "noImageAvailable")!}
        return UIImage(data: data) ?? UIImage(named: "noImageAvailable")!
    }
    
    private func setProductImage() {
        let imageLoader = CachedImageLoader()
        if let url = articleSelected!.thumbnailImage {
            imageLoader.load(path: url, putOn: productImage){imageView, usedCache in
                let url = self.articleSelected!.productImages[0]
                imageLoader.load(path: url, putOn: imageView)
            }
        } else if self.articleSelected!.productImages.count > 0{
            let url = self.articleSelected!.productImages[0]
            imageLoader.load(path: url, putOn: productImage)
        } else {
            productImage.image = UIImage(named:"defaultProfileImage")
        }
        productImage.contentMode = .scaleAspectFit
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        productImage.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 300).isActive = true
        
    }
    
    func setData(username: String, profile_image: String, mannerTemp: Float){
        
        if profile_image == "default" {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        } else {
            CachedImageLoader().load(path: profile_image, putOn: profileImageView)
        }
        
        profileBtn.setTitle(username, for: .normal)
        mannerTempLabel.text = String(mannerTemp) + "°C ☺️"
    }
    
    private func setProfileView() {
        
        profileView.backgroundColor = .white
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.leadingAnchor.constraint(equalTo: productImage.leadingAnchor).isActive = true
        profileView.topAnchor.constraint(equalTo: productImage.bottomAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: productImage.trailingAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 70).isActive = true
        
        profileView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        
        profileView.addSubview(profileBtn)
        profileBtn.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        profileBtn.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        profileBtn.rx.tap.bind{
            let vc = ProfileViewController()
            // TODO: article에서 id 받아와서 프로필 찾고 보내기
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)

        
        profileView.addSubview(mannerTempLabel)
        mannerTempLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 20).isActive = true
        mannerTempLabel.centerXAnchor.constraint(equalTo: profileBtn.centerXAnchor).isActive = true
        
    }
    
    private func setTitleLabel() {
        titleLabel.text = articleSelected?.title
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 60).isActive = true
        
        titleLabel.font = .systemFont(ofSize: 20)
        
    }
    
    private func setCategoryLabel() {
        categoryLabel.text = articleSelected?.category
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        
        categoryLabel.font = .systemFont(ofSize: 12)
    }
    
    
    private func setContentLabel() {
        contentText.numberOfLines = 0
        contentText.text = articleSelected?.content
        
        contentText.translatesAutoresizingMaskIntoConstraints = false
        contentText.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        contentText.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15).isActive = true
        contentText.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        contentText.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        
        contentText.font = .systemFont(ofSize: 15)
    }
    
    private func setLikeBtn() {
        
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.leadingAnchor.constraint(lessThanOrEqualTo: bottomView.leadingAnchor, constant: 10).isActive = true
        likeBtn.centerYAnchor.constraint(lessThanOrEqualTo: bottomView.centerYAnchor).isActive = true
        likeBtn.widthAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
        likeBtn.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
        likeBtn.tintColor = .systemPink
        likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        likeBtn.rx.tap.bind{
            print("click")
            self.isLiked = !self.isLiked
            self.animateHeart()
        }.disposed(by: disposeBag)
        
    }
    
    private func animateHeart() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            self.likeBtn.transform = self.likeBtn.transform.scaledBy(x: 0.8, y: 0.8)
            self.likeBtn.setImage(newImage, for: .normal)
        }, completion: { _  in
            UIView.animate(withDuration: 0.1, animations: {
                self.likeBtn.transform = CGAffineTransform.identity
            })
        })
    }
    
    private func setPriceLabel() {
        let price = articleSelected?.price
        priceLabel.text = "₩ " + String(price!)
        if articleSelected?.isSold == true {
            priceLabel.text = "판매완료"
        }
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: likeBtn.trailingAnchor, constant: 10).isActive = true
        priceLabel.topAnchor.constraint(equalTo: likeBtn.topAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: likeBtn.bottomAnchor).isActive = true
        
        priceLabel.font = .systemFont(ofSize: 18)
        
    }
    
    private func setCommentBtn() {
        
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 20).isActive = true
        commentBtn.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: 10).isActive = true
        commentBtn.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -10).isActive = true
        commentBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20).isActive = true
        
        commentBtn.setTitle("댓글 작성하기", for: .normal)
        commentBtn.backgroundColor = .orange
        commentBtn.setTitleColor(.white, for: .normal)
        commentBtn.layer.cornerRadius = 10
        commentBtn.titleLabel?.font = .systemFont(ofSize: 15)
        
        commentBtn.rx.tap.bind{
            print("click")
            let vc = CommentViewController()
            vc.articleId = self.articleId
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    private func setChatBtn(){
        chatBtn.translatesAutoresizingMaskIntoConstraints = false

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
