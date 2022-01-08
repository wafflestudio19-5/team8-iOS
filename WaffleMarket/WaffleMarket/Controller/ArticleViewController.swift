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
    
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let priceLabel = UILabel()
    let contentLabel = UILabel()
    let productImage = UIImageView()
    let buyBtn = UIButton()
    let disposeBag = DisposeBag()
    var articleId = 0
    var articleSelected: Article?
    
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
        scrollView.addSubview(titleLabel)
        setTitleLabel()
        scrollView.addSubview(categoryLabel)
        setCategoryLabel()
        scrollView.addSubview(contentLabel)
        setContentLabel()
        
    }
    
    private func setBottomView() {
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomView.addSubview(priceLabel)
        setPriceLabel()
        bottomView.addSubview(buyBtn)
        setBuyBtn()
    
    }
    
    private func getArticleImage(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        guard let data = try? Data(contentsOf: url!) else {return UIImage(named: "noImageAvailable") ?? UIImage(named: "noImageAvailable")!}
        return UIImage(data: data) ?? UIImage(named: "noImageAvailable")!
    }
    
    private func setProductImage() {
        if let url = articleSelected?.productImages[0] {
            CachedImageLoader().load(path: url, putOn: productImage)
        }
        productImage.contentMode = .scaleAspectFit
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        productImage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 300).isActive = true
        
    }
    
    private func setTitleLabel() {
        titleLabel.text = articleSelected?.title
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: productImage.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 60).isActive = true
        
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
        contentLabel.text = articleSelected?.content
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor).isActive = true
        contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        
        contentLabel.font = .systemFont(ofSize: 15)
    }
    
    private func setPriceLabel() {
        let price = articleSelected?.price
        priceLabel.text = "₩ " + String(price!)
        if articleSelected?.isSold == true {
            priceLabel.text = "판매완료"
        }
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20).isActive = true
        priceLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15).isActive = true
        
        priceLabel.font = .systemFont(ofSize: 18)
    }
    
    private func setBuyBtn() {
        
        buyBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBtn.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 20).isActive = true
        buyBtn.topAnchor.constraint(equalTo: priceLabel.topAnchor).isActive = true
        buyBtn.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        buyBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20).isActive = true
        
        buyBtn.setTitle("댓글 작성하기", for: .normal)
        buyBtn.backgroundColor = .orange
        buyBtn.setTitleColor(.white, for: .normal)
        buyBtn.layer.cornerRadius = 10
        buyBtn.titleLabel?.font = .systemFont(ofSize: 15)
        
        buyBtn.rx.tap.bind{
            print("click")
            let vc = CommentViewController()
            vc.articleId = self.articleId
            self.navigationController?.pushViewController(vc, animated: true)
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
