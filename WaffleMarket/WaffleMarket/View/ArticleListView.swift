//
//  ArticleListView.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel()
    var imageUrl: String?
    var productImage: UIImageView = UIImageView()
    var priceLabel: UILabel = UILabel()
    var commentLikeLabel: UILabel = UILabel()
    let imageLoader = CachedImageLoader()
    let viewModel = ArticleViewModel()
    let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        commentLikeLabel.text = nil
        imageLoader.cancel()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCell() {
        backgroundColor = .white
        self.heightAnchor.constraint(equalToConstant: 120).isActive = true

        self.contentView.addSubview(productImage)
        setProductImage()
        self.contentView.addSubview(titleLabel)
        setTitleLabel()
        self.contentView.addSubview(priceLabel)
        setPriceLabel()
        self.contentView.addSubview(commentLikeLabel)
        setCommentLikeLabel()
        
    }
    func loadImage(){
        if imageUrl == nil {
            productImage.image = UIImage(named: "defaultProfileImage")
        } else {
            imageLoader.load(path: imageUrl!, putOn: productImage)
        }
    }
    
    private func setProductImage() {
        
        productImage.contentMode = .scaleAspectFit
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    private func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: productImage.topAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setCommentLikeLabel() {
        commentLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLikeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        commentLikeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    
}


class ArticleListView: UIView {
    
    let articleTableView = UITableView()
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    let viewModel = ArticleViewModel()
    var listName: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.addSubview(articleTableView)
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        articleTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        articleTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func getArticleImage(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        guard let data = try? Data(contentsOf: url!) else {return UIImage(named: "noImageAvailable") ?? UIImage(named: "noImageAvailable")!}
        return UIImage(data: data) ?? UIImage(named: "noImageAvailable")!
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
