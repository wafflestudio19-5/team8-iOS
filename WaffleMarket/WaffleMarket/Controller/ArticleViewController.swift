//
//  ArticleViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/07.
//

import UIKit

class ArticleViewController: UIViewController {

    let stackView = UIStackView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let priceLabel = UILabel()
    let contentLabel = UILabel()
    let productImage = UIImageView()
    
    var articleSelected: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        setStackView()
        // Do any additional setup after loading the view.
    }
    
    private func setStackView() {
        
        stackView.addArrangedSubview(titleLabel)
        divider()
        stackView.addArrangedSubview(categoryLabel)
        divider()
        stackView.addArrangedSubview(priceLabel)
        divider()
        stackView.addArrangedSubview(contentLabel)
        divider()
        stackView.addArrangedSubview(productImage)
        divider()
        
        setTitleLabel()
        setCategoryLabel()
        setPriceLabel()
        setContentLabel()
        setProductImage()
        
    }
    
    private func divider() {
        if stackView.arrangedSubviews.count > 0 {
            let separator = UIView()
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separator.backgroundColor = .separator
            stackView.addArrangedSubview(separator)
            separator.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
    
    private func getArticleImage(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        guard let data = try? Data(contentsOf: url!) else {return UIImage(named: "noImageAvailable") ?? UIImage(named: "noImageAvailable")!}
        return UIImage(data: data) ?? UIImage(named: "noImageAvailable")!
    }
    
    private func setTitleLabel() {
        titleLabel.text = articleSelected?.title
    }
    
    private func setCategoryLabel() {
        categoryLabel.text = articleSelected?.category
    }
    
    private func setPriceLabel() {
        let price = articleSelected?.price
        priceLabel.text = String(price!)
    }
    
    private func setContentLabel() {
        contentLabel.text = articleSelected?.content
    }
    
    private func setProductImage() {
        productImage.image =  getArticleImage(urlString: articleSelected?.productImageUrl ?? "")
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
