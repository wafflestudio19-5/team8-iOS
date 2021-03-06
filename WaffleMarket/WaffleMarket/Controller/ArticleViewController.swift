//
//  ArticleViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/07.
//

import UIKit
import RxSwift
import SwiftUI
import RxCocoa
import ImageSlideshow
class UIImageSlideshow: ImageSlideshow{}
class ArticleViewController: UIViewController {

    let scrollView = UIScrollView()
    let bottomView = UIView()
    let profileView = UIView()
    
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let priceLabel = UILabel()
    let contentText = UILabel()
    let slideshow = UIImageSlideshow()
    let commentBtn = UIButton()
    let btnStack = UIStackView()
    let chatBtn = UIButton()
    let likeBtn = UIButton(type: .custom)
    let profileImageView = UIImageView()
    var isProcessingLike = false
    let usernameLabel = UILabel()
    let mannerTempLabel = UILabel()
    let showProfileBtn = UIButton()
    
    let disposeBag = DisposeBag()
    var articleId = 0
    var articleSelected: Article?
    var isLiked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLiked = articleSelected?.user_liked ?? false
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        setScrollView()
        
        setBottomView()
        // Do any additional setup after loading the view.
    }
    
    private func setScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor).isActive = true
        
        scrollView.addSubview(slideshow)
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
        bottomView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomView.addSubview(likeBtn)
        setLikeBtn()
        bottomView.addSubview(priceLabel)
        setPriceLabel()
        bottomView.addSubview(btnStack)
        setBtnStack()
        
    
    }
    
    private func getArticleImage(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        guard let data = try? Data(contentsOf: url!) else {return UIImage(named: "noImageAvailable") ?? UIImage(named: "noImageAvailable")!}
        return UIImage(data: data) ?? UIImage(named: "noImageAvailable")!
    }
    
    private func setProductImage() {
        let imageLoader = CachedImageLoader()
        let tempImageView = UIImageView()
        imageLoader.load(path: self.articleSelected!.product_images[0].thumbnail_url, putOn: tempImageView){imageView, usedCache in
            DispatchQueue.main.async{
                var inputs: [AlamofireSource] = []
                var first = true
                for productImage in self.articleSelected!.product_images {
                    let url = productImage.image_url
                    inputs.append(AlamofireSource(urlString: url, placeholder: first ? tempImageView.image : UIImage(systemName: "photo"))!)
                    first = false
                }
                self.slideshow.setImageInputs(inputs)
            }
        }
        
//        if self.articleSelected!.product_images.count > 0{
//            imageLoader.load(path: self.articleSelected!.product_images[0].thumbnail_url, putOn: productImage){imageView, usedCache in
//                let url = self.articleSelected!.product_images[0].image_url
//                imageLoader.load(path: url, putOn: imageView)
//            }
//        } else {
//            productImage.image = UIImage(named:"defaultProfileImage")
//        }
       //slideshow.contentMode = .scaleAspectFit
        
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        slideshow.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        slideshow.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        slideshow.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        slideshow.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 300).isActive = true
        
    }
    
    func setData(username: String, profile_image: String, mannerTemp: Float){
        
        if profile_image == "default" {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        } else {
            CachedImageLoader().load(path: profile_image, putOn: profileImageView)
        }
        
        usernameLabel.text = username
        mannerTempLabel.text = String(mannerTemp) + "??C"
    }
    
    private func setProfileView() {
        
        profileView.backgroundColor = .white
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.leadingAnchor.constraint(equalTo: slideshow.leadingAnchor).isActive = true
        profileView.topAnchor.constraint(equalTo: slideshow.bottomAnchor, constant: 30).isActive = true
        profileView.trailingAnchor.constraint(equalTo: slideshow.trailingAnchor).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        profileView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: profileView.topAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileView.heightAnchor).isActive = true
        if let url = articleSelected?.seller.profile_image {
            CachedImageLoader().load(path: url, putOn: profileImageView)
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        }
        
        profileImageView.isUserInteractionEnabled = false
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 8
        profileView.addSubview(usernameLabel)
        profileView.addSubview(mannerTempLabel)
        profileView.addSubview(showProfileBtn)
        usernameLabel.adjustsFontSizeToFitWidth = false
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.isUserInteractionEnabled = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 110).isActive = true
        usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: mannerTempLabel.leadingAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileView.topAnchor).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        usernameLabel.text = articleSelected?.seller.username ?? "Waffle Market"
        
        usernameLabel.textColor = .black
        
        
        mannerTempLabel.isUserInteractionEnabled = false
        mannerTempLabel.translatesAutoresizingMaskIntoConstraints = false
        mannerTempLabel.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -150).isActive = true
        mannerTempLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -80).isActive = true
        mannerTempLabel.topAnchor.constraint(equalTo: profileView.topAnchor).isActive = true
        mannerTempLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        mannerTempLabel.text = "--??C";
        if let temperature = articleSelected?.seller.temparature {
            mannerTempLabel.text = "\(temperature)??C"
        }
        
        
        
        showProfileBtn.translatesAutoresizingMaskIntoConstraints = false
        showProfileBtn.leadingAnchor.constraint(equalTo: mannerTempLabel.trailingAnchor).isActive = true
        showProfileBtn.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -20).isActive = true
        showProfileBtn.topAnchor.constraint(equalTo: profileView.topAnchor).isActive = true
        showProfileBtn.bottomAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        showProfileBtn.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        
        showProfileBtn.rx.tap.bind{
            let vc = ProfileViewController()
            vc.user = self.articleSelected?.seller
            // TODO: article?????? id ???????????? ????????? ?????? ?????????
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    private func setTitleLabel() {
        titleLabel.text = articleSelected?.title
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 30).isActive = true
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
        likeBtn.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        likeBtn.rx.tap.bind{
            if self.isProcessingLike {
                self.toast("??????????????????")
                return
            }
            self.isProcessingLike = true
            print("click")
            ArticleAPI.like(articleId: self.articleId).subscribe { response in
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(Article.self, from: response.data) {
                    self.isLiked = decoded.user_liked
                    DispatchQueue.main.async {
                        self.animateHeart()
                    }
                }
                self.isProcessingLike = false
            } onFailure: { error in
                self.isProcessingLike = false
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

            
            
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
        priceLabel.text = "??? " + String(price!)
        if articleSelected?.sold_at != nil {
            priceLabel.text = "????????????"
        }
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(lessThanOrEqualTo: likeBtn.trailingAnchor, constant: 10).isActive = true
        priceLabel.topAnchor.constraint(equalTo: likeBtn.topAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: likeBtn.bottomAnchor).isActive = true
        
        priceLabel.font = .systemFont(ofSize: 18)
        
    }
    
    private func setCommentBtn() {
        
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        
//        commentBtn.setTitle("?????? ????????????", for: .normal)
//        commentBtn.backgroundColor = .orange
//        commentBtn.setTitleColor(.white, for: .normal)
//        commentBtn.layer.cornerRadius = 10
//        commentBtn.titleLabel?.font = .systemFont(ofSize: 15)
        commentBtn.setImage(UIImage(systemName:"text.bubble"), for: .normal)
        
        commentBtn.rx.tap.bind{
            print("click")
            let vc = CommentViewController()
            vc.isOwner = self.articleSelected?.delete_enable ?? false
            vc.articleId = self.articleId
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    private func setChatBtn(){
        chatBtn.translatesAutoresizingMaskIntoConstraints = false
        
//        chatBtn.setTitle("????????????", for: .normal)
        chatBtn.setImage(UIImage(systemName:"message"), for: .normal)
//        chatBtn.backgroundColor = .orange
//        chatBtn.setTitleColor(.white, for: .normal)
//        chatBtn.layer.cornerRadius = 10
//        chatBtn.titleLabel?.font = .systemFont(ofSize: 15)
        chatBtn.rx.tap.bind{
            ChatAPI.create(article_id: self.articleId).subscribe { response in
                let decoder = JSONDecoder()
                print(String(decoding: response.data, as: UTF8.self))
                if let decoded = try? decoder.decode(ChatroomResponse.self, from: response.data){
                    
                    let imageView = UIImageView()
                    CachedImageLoader().load(path: decoded.profile_image, putOn: imageView) { imageView, usedCache in
                        DispatchQueue.main.async{
                            let chatView = ChatView()
                            if !ChatCommunicator.shared.checkConnection(roomName: decoded.roomname){
                                ChatCommunicator.shared.connect(roomName: decoded.roomname)
                            }
                            let me = ChatUser(name: AccountManager.userProfile!.userName!, avatar: nil, isCurrentUser: true)
                            let opponent = ChatUser(name: decoded.username, avatar: imageView.image)
                            let dataSource = DataSource(me:me, opponent: opponent, messages: ChatCommunicator.shared.chatLog[decoded.roomname] ?? [], productImage: decoded.product_image!.image_url)
                            let chatHelper = ChatHelper(roomName: decoded.roomname, dataSource: dataSource)
                            let vc = UIHostingController(rootView: chatView.environmentObject(chatHelper))
                            vc.navigationItem.title = decoded.username
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                } else {
                    self.toast("????????? ???????????????")
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

            
        }.disposed(by: disposeBag)
    }
    
    private func setBtnStack(){
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 20).isActive = true
        btnStack.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        btnStack.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        btnStack.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20).isActive = true
        btnStack.axis = .horizontal
        btnStack.spacing = 10
        btnStack.distribution = .fillEqually
        btnStack.addArrangedSubview(commentBtn)
        setCommentBtn()
        btnStack.addArrangedSubview(chatBtn)
        setChatBtn()
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
